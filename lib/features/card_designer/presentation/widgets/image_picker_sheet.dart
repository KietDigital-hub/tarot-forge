import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/tarot_deck_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/services/gemini_api_key_store.dart';
import '../../../../core/services/gemini_image_service.dart';
import '../../../customer_profile/domain/models/customer_profile.dart';
import '../../../customer_profile/presentation/providers/customer_profile_provider.dart';
import '../providers/card_designer_provider.dart';

/// Modal sheet chọn ảnh cho lá bài: Thư viện có sẵn, Tải từ máy, hoặc Tạo ảnh bằng AI.
class ImagePickerSheet extends ConsumerStatefulWidget {
  final bool isDark;

  const ImagePickerSheet({super.key, required this.isDark});

  static Future<void> show(BuildContext context, bool isDark) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ImagePickerSheet(isDark: isDark),
    );
  }

  @override
  ConsumerState<ImagePickerSheet> createState() => _ImagePickerSheetState();
}

class _ImagePickerSheetState extends ConsumerState<ImagePickerSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _aiPromptController;

  bool _isGeneratingAi = false;
  Uint8List? _generatedImageBytes;
  String? _generatedPromptUsed;
  String? _generationError;

  String? _apiKey;
  bool _apiKeyLoaded = false;
  late TextEditingController _apiKeyController;
  bool _isEditingApiKey = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _aiPromptController = TextEditingController();
    _apiKeyController = TextEditingController();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final key = await GeminiApiKeyStore.load();
    if (mounted) {
      setState(() {
        _apiKey = key;
        _apiKeyLoaded = true;
        _isEditingApiKey = key == null;
      });
    }
  }

  Future<void> _saveApiKey() async {
    final value = _apiKeyController.text.trim();
    if (value.isEmpty) return;
    await GeminiApiKeyStore.save(value);
    if (mounted) {
      setState(() {
        _apiKey = value;
        _isEditingApiKey = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu API key trên thiết bị này.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _aiPromptController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _pickCustomFile() async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.image,
      );

      if (file != null) {
        final bytes = await file.xFile.readAsBytes();
        ref.read(cardDesignerProvider.notifier).setCustomImage(
              bytes,
              file.name,
            );
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã tải hình minh họa "${file.name}"!'),
              backgroundColor: AppColors.goldDark,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi chọn ảnh: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  /// Gọi Gemini API thật để sinh ảnh Tarot theo prompt kết hợp sở thích khách hàng.
  Future<void> _handleGenerateAiImage() async {
    final activeCard = ref.read(cardDesignerProvider);
    final customerProfile = ref.read(customerProfileProvider);

    final userDesc = _aiPromptController.text.trim();
    if (userDesc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập mô tả ý tưởng cho lá bài trước khi tạo.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final apiKey = _apiKey;
    if (apiKey == null || apiKey.isEmpty) {
      setState(() => _isEditingApiKey = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nhập API key Gemini trước khi tạo ảnh (miễn phí tại aistudio.google.com).'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isGeneratingAi = true;
      _generatedImageBytes = null;
      _generationError = null;
    });

    // 1. Xây dựng prompt chuẩn Tarot kết hợp từ khóa khách hàng từ Bước 1
    final fullPrompt = customerProfile.buildTarotPrompt(
      cardName: activeCard.name,
      userDescription: userDesc,
    );
    _generatedPromptUsed = fullPrompt;

    try {
      // 2. Gọi Gemini API để sinh ảnh thật
      final bytes = await GeminiImageService.generateTarotImage(
        apiKey: apiKey,
        prompt: fullPrompt,
      );

      if (mounted) {
        setState(() {
          _isGeneratingAi = false;
          _generatedImageBytes = bytes;
        });
      }
    } on GeminiImageException catch (e) {
      if (mounted) {
        setState(() {
          _isGeneratingAi = false;
          _generationError = e.message;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGeneratingAi = false;
          _generationError = 'Lỗi không xác định khi tạo ảnh.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tạo ảnh: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _applyGeneratedAiImage() {
    if (_generatedImageBytes != null) {
      final activeCard = ref.read(cardDesignerProvider);
      ref.read(cardDesignerProvider.notifier).setCustomImage(
            _generatedImageBytes!,
            'AI_${activeCard.name.replaceAll(' ', '_')}.jpg',
          );
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã áp dụng hình ảnh AI cho lá ${activeCard.name}!'),
          backgroundColor: AppColors.goldDark,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final gold = isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary;
    final activeCard = ref.watch(cardDesignerProvider);
    final customerProfile = ref.watch(customerProfileProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: gold.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Title
          Row(
            children: [
              Icon(Icons.photo_library_outlined, color: gold, size: 20),
              const SizedBox(width: 8),
              Text(
                'HÌNH ẢNH LÁ BÀI',
                style: AppTypography.screenTitle(isDark: isDark),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3-Segment Tab Bar
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: gold.withValues(alpha: 0.2)),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: gold,
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: isDark ? AppColors.darkBackground : Colors.white,
              unselectedLabelColor: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              labelStyle: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              tabs: const [
                Tab(text: 'THƯ VIỆN CÓ SẴN'),
                Tab(text: 'TẢI TỪ MÁY'),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome, size: 14),
                      SizedBox(width: 4),
                      Text('TẠO BẰNG AI'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tab Content
          Flexible(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Thư viện có sẵn
                _buildGalleryTab(activeCard, gold, isDark),

                // Tab 2: Tải từ máy
                _buildUploadTab(gold, isDark),

                // Tab 3: Tạo bằng AI
                _buildAiGenerateTab(customerProfile, activeCard, gold, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tab 1: Thư viện có sẵn
  Widget _buildGalleryTab(dynamic activeCard, Color gold, bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chọn từ bộ tranh mẫu Major Arcana kinh điển:',
            style: AppTypography.body(isDark: isDark, fontSize: 13),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.65,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: TarotDeckData.samplePresets.length,
            itemBuilder: (context, index) {
              final preset = TarotDeckData.samplePresets[index];
              final isSelected = !activeCard.hasCustomImage &&
                  activeCard.assetImagePath == preset.assetImagePath;

              return InkWell(
                onTap: () {
                  ref
                      .read(cardDesignerProvider.notifier)
                      .selectAssetImage(preset.assetImagePath);
                  Navigator.of(context).pop();
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? gold : gold.withValues(alpha: 0.25),
                      width: isSelected ? 2.5 : 1.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          preset.assetImagePath,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              preset.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Cinzel',
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: AppColors.goldPrimary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Tab 2: Tải từ máy
  Widget _buildUploadTab(Color gold, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: InkWell(
          onTap: _pickCustomFile,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: gold, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: gold.withValues(alpha: 0.15),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_upload_outlined, color: gold, size: 40),
                const SizedBox(height: 12),
                Text(
                  'BẤM ĐỂ CHỌN ẢNH TỪ MÁY',
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: gold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Hỗ trợ file PNG, JPG hoặc WEBP chất lượng cao.\nẢnh sẽ được căn chỉnh tự động vừa vặn khung lá bài.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Tab 3: Tạo ảnh bằng AI (Gemini)
  Widget _buildAiGenerateTab(
    CustomerProfile profile,
    dynamic activeCard,
    Color gold,
    bool isDark,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // API key Gemini
          _buildApiKeySection(gold, isDark),
          const SizedBox(height: 14),

          // Banner thông tin sở thích khách hàng đã inject
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: gold.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: gold.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.tune, color: gold, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Đã kết hợp sở thích: ${profile.style} • ${profile.favoriteColor} • ${profile.theme}',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: gold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Ô nhập mô tả ngắn ý tưởng cho lá bài
          Text(
            'MÔ TẢ Ý TƯỞNG CHO LÁ BÀI (${activeCard.name}):',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _aiPromptController,
            maxLines: 2,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'VD: Nữ hoàng ngồi trên ngai vàng nguy nga giữa rừng hoa hồng, ánh sáng thần thánh...',
              hintStyle: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 12,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
              filled: true,
              fillColor: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.lightSurfaceVariant,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: gold.withValues(alpha: 0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: gold.withValues(alpha: 0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: gold, width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 12),

          if (_generationError != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _generationError!,
                      style: const TextStyle(fontFamily: 'Outfit', fontSize: 11.5, color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Nút tạo ảnh AI
          if (_isGeneratingAi)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(color: gold),
                    const SizedBox(height: 8),
                    Text(
                      'AI đang phác họa minh họa Tarot chuẩn phong cách...',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 12,
                        color: gold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: _handleGenerateAiImage,
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: const Text('TẠO ẢNH BẰNG AI (GEMINI)'),
              ),
            ),

          // Khung hiển thị kết quả tạo ảnh
          if (_generatedImageBytes != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: gold, width: 1.2),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'KẾT QUẢ TẠO ẢNH TỪ AI',
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: gold,
                        ),
                      ),
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 160,
                      width: 110,
                      child: Image.memory(
                        _generatedImageBytes!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (_generatedPromptUsed != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Prompt chuẩn Tarot: ${_generatedPromptUsed!.split('\n').first}',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 10,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _handleGenerateAiImage,
                          child: const Text('TẠO LẠI'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _applyGeneratedAiImage,
                          child: const Text('SỬ DỤNG ẢNH NÀY'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// Ô nhập / hiển thị API key Gemini của người dùng (lưu cục bộ trên thiết bị).
  Widget _buildApiKeySection(Color gold, bool isDark) {
    if (!_apiKeyLoaded) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (!_isEditingApiKey && _apiKey != null) {
      return Row(
        children: [
          Icon(Icons.vpn_key, size: 14, color: gold),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Gemini API key: •••• (đã lưu trên thiết bị này)',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 11,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _isEditingApiKey = true),
            child: const Text('ĐỔI KEY', style: TextStyle(fontSize: 11)),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NHẬP GEMINI API KEY ĐỂ TẠO ẢNH',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: gold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Lấy API key miễn phí tại aistudio.google.com. Key chỉ lưu trên thiết bị/trình duyệt của bạn, không gửi lên GitHub hay máy chủ nào khác.',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 10.5,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _apiKeyController,
                  obscureText: true,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Dán API key vào đây',
                    isDense: true,
                    filled: true,
                    fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: gold.withValues(alpha: 0.3)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _saveApiKey,
                child: const Text('LƯU'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/tarot_deck_data.dart';
import '../../../../core/services/gemini_api_key_store.dart';
import '../../../../core/services/gemini_image_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mystic_particles.dart';
import '../../../card_designer/presentation/providers/card_designer_provider.dart';
import '../../../card_designer/presentation/screens/card_designer_screen.dart';
import '../../domain/models/customer_profile.dart';
import '../providers/customer_profile_provider.dart';

/// Màn hình khởi đầu (Bước 1): Khách hàng nhập thông tin và sở thích thiết kế bộ bài.
class CustomerProfileScreen extends ConsumerStatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  ConsumerState<CustomerProfileScreen> createState() =>
      _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends ConsumerState<CustomerProfileScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late TextEditingController _notesController;

  late String _selectedStyle;
  late String _selectedColor;
  late String _selectedTheme;

  bool _isLoading = false;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  final List<Map<String, String>> _styleOptions = const [
    {'name': 'Huyền bí', 'icon': '🔮', 'desc': 'Biểu tượng chiêm tinh & ma thuật'},
    {'name': 'Cổ điển', 'icon': '📜', 'desc': 'Khắc gỗ Victorian phong cách Rider-Waite'},
    {'name': 'Tối giản', 'icon': '📐', 'desc': 'Đường nét thanh mảnh & hình học giả kim'},
    {'name': 'Hoàng gia', 'icon': '👑', 'desc': 'Dát vàng vương giả & gấm nhung quyền uy'},
    {'name': 'Thiên nhiên', 'icon': '🌿', 'desc': 'Thảo mộc, cỏ cây & muông thú linh thiêng'},
    {'name': 'Gothic tối', 'icon': '🦇', 'desc': 'Bóng tối, kiến trúc Gothic, ánh nến ma mị'},
    {'name': 'Nghệ thuật Nouveau', 'icon': '🌺', 'desc': 'Đường cong mềm mại, hoa văn Art Nouveau'},
    {'name': 'Phù thủy dân gian', 'icon': '🧙‍♀️', 'desc': 'Cỏ cây rừng sâu, lọ thuốc, sách cổ'},
    {'name': 'Phương Đông huyền bí', 'icon': '🏮', 'desc': 'Rồng phượng, mực tàu, hoa văn Á Đông'},
    {'name': 'Ai Cập cổ đại', 'icon': '𓁿', 'desc': 'Kim tự tháp, tượng thần, chữ tượng hình'},
    {'name': 'Thiên hà vũ trụ', 'icon': '🌌', 'desc': 'Tinh vân, dải ngân hà, ánh sao huyền ảo'},
    {'name': 'Cyberpunk huyền huyễn', 'icon': '🌃', 'desc': 'Ánh neon pha trộn biểu tượng huyền bí'},
    {'name': 'Baroque tráng lệ', 'icon': '🎭', 'desc': 'Chi tiết cầu kỳ, tương phản ánh sáng mạnh'},
    {'name': 'Thủy mặc tối giản', 'icon': '🖌️', 'desc': 'Nét vẽ mực loang, khoảng trắng tĩnh lặng'},
    {'name': 'Rừng nhiệt đới', 'icon': '🌴', 'desc': 'Lá cây rậm rạp, sắc xanh sống động'},
    {'name': 'Đại dương huyền bí', 'icon': '🌊', 'desc': 'Sóng nước, sinh vật biển sâu, ánh bạc'},
    {'name': 'Hoàng hôn sa mạc', 'icon': '🏜️', 'desc': 'Cát vàng, ánh chiều tà, xương rồng'},
    {'name': 'Băng giá phương Bắc', 'icon': '❄️', 'desc': 'Cực quang, băng tuyết, ánh sáng lạnh'},
    {'name': 'Cổ tích Châu Âu', 'icon': '🏰', 'desc': 'Lâu đài, rừng cổ tích, ánh sáng ấm áp'},
    {'name': 'Hiện đại tối giản neon', 'icon': '✨', 'desc': 'Đường nét sắc gọn, ánh sáng neon tinh tế'},
  ];

  final List<Map<String, dynamic>> _colorOptions = const [
    {
      'name': 'Vàng Kim & Chàm Tím',
      'desc': 'Thần bí & Khai sáng',
      'colors': [Color(0xFF2A1B3D), Color(0xFFD4AF37)],
    },
    {
      'name': 'Đỏ Nhung & Đen Huyền',
      'desc': 'Quyền năng & Quyến rũ',
      'colors': [Color(0xFF4A1828), Color(0xFFB33939)],
    },
    {
      'name': 'Xanh Ngọc & Đồng Cổ',
      'desc': 'Thanh tao & Cổ xưa',
      'colors': [Color(0xFF133B3E), Color(0xFFC29B38)],
    },
    {
      'name': 'Bạc Tinh Tú & Xanh Băng',
      'desc': 'Thanh khiết & Vũ trụ',
      'colors': [Color(0xFF1B2A4A), Color(0xFF90B4CE)],
    },
    {
      'name': 'Cam Hoàng Hôn & Nâu Đất',
      'desc': 'Ấm Áp & Chữa Lành',
      'colors': [Color(0xFF8B4513), Color(0xFFE07A5F)],
    },
    {
      'name': 'Hồng Phấn & Bạc',
      'desc': 'Dịu Dàng & Mộng Mơ',
      'colors': [Color(0xFFC0C0C0), Color(0xFFE8A598)],
    },
    {
      'name': 'Tím Than & Xanh Lá Đậm',
      'desc': 'Bí Ẩn & Sâu Lắng',
      'colors': [Color(0xFF1E1035), Color(0xFF1B4332)],
    },
    {
      'name': 'Trắng Ngà & Vàng Nhạt',
      'desc': 'Thanh Khiết & Nhẹ Nhàng',
      'colors': [Color(0xFFF4F1DE), Color(0xFFE9C46A)],
    },
    {
      'name': 'Đen Tuyền & Đỏ Máu',
      'desc': 'Quyền Lực & Đam Mê',
      'colors': [Color(0xFF0D0D0D), Color(0xFF8A0303)],
    },
    {
      'name': 'Xanh Dương Hoàng Gia & Vàng Đồng',
      'desc': 'Uy Nghi & Cổ Kính',
      'colors': [Color(0xFF0F2042), Color(0xFFD4AF37)],
    },
    {
      'name': 'Xanh Lục Rừng & Nâu Gỗ',
      'desc': 'Tự Nhiên & Vững Chãi',
      'colors': [Color(0xFF2D5A27), Color(0xFF5C4033)],
    },
    {
      'name': 'Cầu Vồng Ánh Kim & Trắng',
      'desc': 'Huyền Ảo & Đa Sắc',
      'colors': [Color(0xFF9D4EDD), Color(0xFF5BC0BE)],
    },
  ];

  final List<Map<String, String>> _themeOptions = const [
    {'name': 'Thiên văn & Tinh tú', 'icon': '🌌'},
    {'name': 'Phù thủy & Huyền thuật', 'icon': '🧙‍♀️'},
    {'name': 'Thiên thần & Thánh tích', 'icon': '🕊️'},
    {'name': 'Hoa lá & Thảo mộc', 'icon': '🌸'},
    {'name': 'Thần thoại cổ đại', 'icon': '🏛️'},
  ];

  @override
  void initState() {
    super.initState();
    final profile = ref.read(customerProfileProvider);
    _nameController = TextEditingController(text: profile.name);
    _notesController = TextEditingController(text: profile.notes);
    _selectedStyle = profile.style;
    _selectedColor = profile.favoriteColor;
    _selectedTheme = profile.theme;

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('TestWidgetsFlutterBinding');
    if (!isTest) {
      _glowController.repeat(reverse: true);
    }
    _glowAnimation = CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _handleStartDesign() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim().isEmpty
          ? 'Nhà Chiêm Tinh'
          : _nameController.text.trim();

      // 1. Lưu hồ sơ khách hàng
      final updatedProfile = ref.read(customerProfileProvider).copyWith(
            name: name,
            style: _selectedStyle,
            favoriteColor: _selectedColor,
            theme: _selectedTheme,
            notes: _notesController.text.trim(),
          );

      ref.read(customerProfileProvider.notifier).saveProfile(updatedProfile);

      // 2. Tự động gợi ý template và lá bài kinh điển phù hợp
      final suggestedTemplate = updatedProfile.suggestedTemplateId;
      final suggestedPreset = updatedProfile.suggestedPreset;

      final cardNotifier = ref.read(cardDesignerProvider.notifier);
      cardNotifier.selectTemplate(suggestedTemplate);
      cardNotifier.applyPreset(suggestedPreset);

      // 3. Kiểm tra xem khách đã lưu Gemini API key trên thiết bị chưa
      final apiKey = await GeminiApiKeyStore.load();

      if (!mounted) return;

      if (apiKey != null && apiKey.isNotEmpty) {
        // Khách ĐÃ CÓ API key: Triệu hồi Gemini AI tạo ảnh độc bản luôn
        await _generateAiImageAndNavigate(
          apiKey: apiKey,
          profile: updatedProfile,
          preset: suggestedPreset,
        );
      } else {
        // Khách CHƯA CÓ API key: Điều hướng ngay với tranh mẫu & gợi ý tạo bằng AI
        _navigateToDesigner();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✨ Đã áp dụng lá "${suggestedPreset.name}" & khung viền "${_getTemplateName(suggestedTemplate)}". Bạn có thể vào "Hình ảnh" > "Tạo bằng AI" để vẽ tranh riêng bất cứ lúc nào!',
              style: const TextStyle(fontFamily: 'Outfit'),
            ),
            backgroundColor: AppColors.goldDark,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'ĐÃ HIỂU',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _generateAiImageAndNavigate({
    required String apiKey,
    required CustomerProfile profile,
    required TarotPreset preset,
  }) async {
    final themeMode = ref.read(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final gold = isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary;

    bool cancelled = false;

    // Hiển thị hộp thoại loading huyền ảo
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor:
                isDark ? AppColors.darkSurface : AppColors.lightSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: gold.withValues(alpha: 0.4)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: CircularProgressIndicator(
                          color: gold,
                          strokeWidth: 3,
                        ),
                      ),
                      Icon(Icons.auto_awesome, color: gold, size: 28),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'ĐANG TRIỆU HỒI GEMINI AI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: gold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Đang sáng tạo bức họa độc bản cho lá "${preset.name}" theo sở thích của bạn...',
                    textAlign: TextAlign.center,
                    style: AppTypography.body(isDark: isDark, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      cancelled = true;
                      Navigator.of(dialogCtx).pop();
                      _navigateToDesigner();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Đã dùng tranh mẫu "${preset.name}". Bạn có thể tạo ảnh AI sau trong mục "Hình ảnh".',
                            style: const TextStyle(fontFamily: 'Outfit'),
                          ),
                          backgroundColor: gold,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: gold.withValues(alpha: 0.4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'BỎ QUA & VÀO THIẾT KẾ NGAY',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    final prompt = profile.buildTarotPrompt(
      cardName: preset.name,
      userDescription: profile.notes.isNotEmpty
          ? profile.notes
          : 'Archetype for ${preset.name}, theme: ${profile.theme}',
    );

    try {
      final bytes = await GeminiImageService.generateTarotImage(
        apiKey: apiKey,
        prompt: prompt,
      );

      if (!mounted || cancelled) return;

      // Đóng dialog loading
      Navigator.of(context, rootNavigator: true).pop();

      // Cập nhật ảnh AI vào lá bài
      ref.read(cardDesignerProvider.notifier).setCustomImage(
            bytes,
            'AI_${preset.name.replaceAll(' ', '_')}.jpg',
          );

      _navigateToDesigner();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '✨ Trí tuệ nhân tạo Gemini đã dệt xong tranh cho lá "${preset.name}"!',
                  style: const TextStyle(
                      fontFamily: 'Outfit', fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.goldDark,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted || cancelled) return;

      // Đóng dialog loading
      Navigator.of(context, rootNavigator: true).pop();

      _navigateToDesigner();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không thể tạo ảnh AI (${e.toString()}). Đã dùng tranh mẫu "${preset.name}".',
            style: const TextStyle(fontFamily: 'Outfit'),
          ),
          backgroundColor: Colors.orange.shade800,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _navigateToDesigner() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const CardDesignerScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.04, 0.0);
          const end = Offset.zero;
          final curve = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return SlideTransition(
            position: Tween<Offset>(begin: begin, end: end).animate(curve),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  String _getTemplateName(String id) {
    switch (id) {
      case 'classic_arcana':
        return 'Classic Arcana';
      case 'celestial_mystic':
        return 'Celestial Mystic';
      case 'minimalist_alchemy':
        return 'Minimalist Alchemy';
      case 'full_bleed_art':
        return 'Full-Bleed Art';
      default:
        return id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final gold = isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TAROT FORGE',
          style: AppTypography.screenTitle(isDark: isDark),
        ),
        actions: [
          // Theme Toggle
          IconButton(
            tooltip: isDark ? 'Giao diện sáng' : 'Giao diện tối',
            icon: Icon(
              isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round_outlined,
              color: gold,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: MysticParticlesOverlay(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF221336), const Color(0xFF140B22)]
                          : [const Color(0xFFF9F5EC), const Color(0xFFEBE0CD)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: gold.withValues(alpha: 0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: gold.withValues(alpha: isDark ? 0.15 : 0.08),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.auto_awesome, color: gold, size: 28),
                      const SizedBox(height: 8),
                      Text(
                        'BƯỚC 1: HỒ SƠ BỘ BÀI CÁ NHÂN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.0,
                          color: gold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Chia sẻ ý niệm và phong cách yêu thích để Tarot Forge gợi ý bố cục và tranh minh họa hoàn hảo nhất cho bạn.',
                        textAlign: TextAlign.center,
                        style: AppTypography.body(isDark: isDark, fontSize: 12.5),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 1. Tên khách hàng
                _buildSectionTitle(
                  icon: Icons.person_outline,
                  title: 'TÊN KHÁCH HÀNG / NGƯỜI SỞ HỮU',
                  gold: gold,
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Nhập tên của bạn hoặc nghệ danh (VD: Linh Đan, Artemis)',
                    hintStyle: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    prefixIcon: Icon(Icons.badge_outlined, color: gold, size: 20),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.lightSurfaceVariant,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: gold.withValues(alpha: 0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: gold.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: gold, width: 1.5),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 2. Phong cách bài Tarot yêu thích
                _buildSectionTitle(
                  icon: Icons.style_outlined,
                  title: 'PHONG CÁCH NGHỆ THUẬT YÊU THÍCH',
                  gold: gold,
                  isDark: isDark,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _styleOptions.map((opt) {
                    final isSelected = _selectedStyle == opt['name'];
                    return AnimatedScale(
                      scale: isSelected ? 1.04 : 1.0,
                      duration: const Duration(milliseconds: 160),
                      curve: Curves.easeOutBack,
                      child: ChoiceChip(
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedStyle = opt['name']!);
                        },
                        avatar: Text(opt['icon']!, style: const TextStyle(fontSize: 14)),
                        label: Text(
                          opt['name']!,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? (isDark ? AppColors.darkBackground : Colors.white)
                                : (isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary),
                          ),
                        ),
                        selectedColor: gold,
                        backgroundColor: isDark
                            ? AppColors.darkSurfaceVariant
                            : AppColors.lightSurfaceVariant,
                        side: BorderSide(
                          color: isSelected ? gold : gold.withValues(alpha: 0.25),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // 3. Tông màu chủ đạo
                _buildSectionTitle(
                  icon: Icons.palette_outlined,
                  title: 'TÔNG MÀU SẮC CHỦ ĐẠO',
                  gold: gold,
                  isDark: isDark,
                ),
                const SizedBox(height: 10),
                Column(
                  children: _colorOptions.map((opt) {
                    final isSelected = _selectedColor == opt['name'];
                    final List<Color> colors = opt['colors'] as List<Color>;

                    return AnimatedScale(
                      scale: isSelected ? 1.02 : 1.0,
                      duration: const Duration(milliseconds: 160),
                      curve: Curves.easeOutBack,
                      child: InkWell(
                        onTap: () => setState(() => _selectedColor = opt['name'] as String),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? gold.withValues(alpha: 0.12)
                                : (isDark
                                    ? AppColors.darkSurfaceVariant
                                    : AppColors.lightSurfaceVariant),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? gold : gold.withValues(alpha: 0.2),
                              width: isSelected ? 1.8 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Color swatch circles
                              Row(
                                children: colors.map((c) {
                                  return Container(
                                    width: 22,
                                    height: 22,
                                    margin: const EdgeInsets.only(right: 6),
                                    decoration: BoxDecoration(
                                      color: c,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white24),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      opt['name'] as String,
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? gold
                                            : (isDark
                                                ? AppColors.darkTextPrimary
                                                : AppColors.lightTextPrimary),
                                      ),
                                    ),
                                    Text(
                                      opt['desc'] as String,
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 11,
                                        color: isDark
                                            ? AppColors.darkTextMuted
                                            : AppColors.lightTextMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(Icons.check_circle, color: gold, size: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // 4. Chủ đề mong muốn
                _buildSectionTitle(
                  icon: Icons.flare_outlined,
                  title: 'CHỦ ĐỀ HÌNH TƯỢNG MONG MUỐN',
                  gold: gold,
                  isDark: isDark,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _themeOptions.map((opt) {
                    final isSelected = _selectedTheme == opt['name'];
                    return AnimatedScale(
                      scale: isSelected ? 1.04 : 1.0,
                      duration: const Duration(milliseconds: 160),
                      curve: Curves.easeOutBack,
                      child: ChoiceChip(
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedTheme = opt['name']!);
                        },
                        avatar: Text(opt['icon']!, style: const TextStyle(fontSize: 14)),
                        label: Text(
                          opt['name']!,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? (isDark ? AppColors.darkBackground : Colors.white)
                                : (isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary),
                          ),
                        ),
                        selectedColor: gold,
                        backgroundColor: isDark
                            ? AppColors.darkSurfaceVariant
                            : AppColors.lightSurfaceVariant,
                        side: BorderSide(
                          color: isSelected ? gold : gold.withValues(alpha: 0.25),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // 5. Ghi chú & Ý niệm riêng
                _buildSectionTitle(
                  icon: Icons.note_alt_outlined,
                  title: 'GHI CHÚ & TÂM NIỆM RIÊNG (TÙY CHỌN)',
                  gold: gold,
                  isDark: isDark,
                ),
                const SizedBox(height: 4),
                Text(
                  '(Lưu ý: nội dung này chỉ ảnh hưởng đến ảnh khi bạn đã gắn API key AI ở bước sau — chưa gắn API key thì ghi gì cũng chưa có tác dụng)',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 11.5,
                    fontStyle: FontStyle.italic,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Nhập tâm niệm của bạn (VD: Muốn bộ bài chữa lành, tặng người yêu, tông màu ấm áp...)',
                    hintStyle: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.lightSurfaceVariant,
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: gold.withValues(alpha: 0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: gold.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: gold, width: 1.5),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Button: Bắt đầu thiết kế bài với hiệu ứng hào quang vàng thở (idle aura)
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: gold.withValues(
                              alpha: _isLoading
                                  ? 0.0
                                  : (isDark ? 0.20 : 0.12) + 0.30 * _glowAnimation.value,
                            ),
                            blurRadius: 10 + 12 * _glowAnimation.value,
                            spreadRadius: 1 + 2 * _glowAnimation.value,
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _handleStartDesign,
                      icon: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: isDark
                                    ? AppColors.darkBackground
                                    : Colors.white,
                              ),
                            )
                          : const Icon(Icons.arrow_forward, size: 20),
                      label: Text(
                        _isLoading
                            ? 'ĐANG KHỞI TẠO BỘ BÀI...'
                            : 'BẮT ĐẦU THIẾT KẾ BÀI',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required Color gold,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, color: gold, size: 16),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTypography.sectionHeader(isDark: isDark),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../card_designer/presentation/providers/card_designer_provider.dart';
import '../../../card_designer/presentation/screens/card_designer_screen.dart';
import '../providers/customer_profile_provider.dart';

/// Màn hình khởi đầu (Bước 1): Khách hàng nhập thông tin và sở thích thiết kế bộ bài.
class CustomerProfileScreen extends ConsumerStatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  ConsumerState<CustomerProfileScreen> createState() =>
      _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends ConsumerState<CustomerProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _notesController;

  late String _selectedStyle;
  late String _selectedColor;
  late String _selectedTheme;

  final List<Map<String, String>> _styleOptions = const [
    {'name': 'Huyền bí', 'icon': '🔮', 'desc': 'Biểu tượng chiêm tinh & ma thuật'},
    {'name': 'Cổ điển', 'icon': '📜', 'desc': 'Khắc gỗ Victorian phong cách Rider-Waite'},
    {'name': 'Tối giản', 'icon': '📐', 'desc': 'Đường nét thanh mảnh & hình học giả kim'},
    {'name': 'Hoàng gia', 'icon': '👑', 'desc': 'Dát vàng vương giả & gấm nhung quyền uy'},
    {'name': 'Thiên nhiên', 'icon': '🌿', 'desc': 'Thảo mộc, cỏ cây & muông thú linh thiêng'},
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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleStartDesign() {
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

    // 2. Tự động gợi ý và kích hoạt template tương ứng
    final suggestedTemplate = updatedProfile.suggestedTemplateId;
    ref.read(cardDesignerProvider.notifier).selectTemplate(suggestedTemplate);

    // 3. Chuyển tiếp sang màn hình Card Designer
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CardDesignerScreen(),
      ),
    );
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
      body: SafeArea(
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
                  return ChoiceChip(
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

                  return InkWell(
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
                  return ChoiceChip(
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

              // Button: Bắt đầu thiết kế bài
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _handleStartDesign,
                  icon: const Icon(Icons.arrow_forward, size: 20),
                  label: const Text('BẮT ĐẦU THIẾT KẾ BÀI'),
                ),
              ),

              const SizedBox(height: 20),
            ],
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

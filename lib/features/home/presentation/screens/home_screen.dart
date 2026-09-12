import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/gold_shimmer_border.dart';
import '../../../../core/widgets/mystic_particles.dart';
import '../../../../core/widgets/tilt_card_container.dart';
import '../../../card_designer/presentation/providers/card_designer_provider.dart';
import '../../../customer_profile/presentation/screens/customer_profile_screen.dart';
import '../../../deck_manager/presentation/screens/deck_manager_screen.dart';
import '../../../help/presentation/screens/help_guide_screen.dart';

/// Màn hình Home: Cổng chào đón và giới thiệu ứng dụng Tarot Forge.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('TestWidgetsFlutterBinding');
    if (!isTest) {
      _pulseController.repeat(reverse: true);
    }

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
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
            tooltip: isDark ? 'Chuyển sang giao diện sáng' : 'Chuyển sang giao diện tối',
            icon: Icon(
              isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round_outlined,
              color: gold,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: MysticParticlesOverlay(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Eyebrow badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: gold.withValues(alpha: isDark ? 0.15 : 0.10),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: gold.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, size: 13, color: gold),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'XƯỞNG CHẾ TÁC BÀI TAROT CHUYÊN NGHIỆP',
                              style: TextStyle(
                                fontFamily: 'Cinzel',
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                                color: gold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // App Title
                    Text(
                      'TAROT FORGE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Cinzel',
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4.0,
                        color: gold,
                        shadows: [
                          Shadow(
                            color: gold.withValues(alpha: isDark ? 0.4 : 0.2),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Tagline
                    Text(
                      'Tự thiết kế bộ bài Tarot của riêng bạn, chuẩn in ấn chuyên nghiệp',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14.5,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Hero Artwork Showcase Card (3D Tilt & Shimmer)
                    TiltCardContainer(
                      borderRadius: BorderRadius.circular(16),
                      child: GoldShimmerBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderWidth: 2.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            width: 200,
                            height: 330,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  'assets/images/the_star.jpg',
                                  fit: BoxFit.cover,
                                ),
                                // Gradient shading at bottom
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.85),
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'XVII • NGÔI SAO',
                                          style: TextStyle(
                                            fontFamily: 'Cinzel',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2.0,
                                            color: AppColors.goldBright,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '70x120mm • 300 DPI Bleed',
                                          style: TextStyle(
                                            fontFamily: 'Outfit',
                                            fontSize: 10,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Primary Action Button: BẮT ĐẦU THIẾT KẾ BỘ BÀI MỚI
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: gold.withValues(
                                  alpha: (isDark ? 0.25 : 0.15) + 0.25 * _pulseAnimation.value,
                                ),
                                blurRadius: 12 + 12 * _pulseAnimation.value,
                                spreadRadius: 1 + 2 * _pulseAnimation.value,
                              ),
                            ],
                          ),
                          child: child,
                        );
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const CustomerProfileScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.auto_awesome, size: 20),
                          label: const Text(
                            'BẮT ĐẦU THIẾT KẾ BỘ BÀI MỚI',
                            style: TextStyle(
                              fontFamily: 'Cinzel',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gold,
                            foregroundColor: isDark ? AppColors.darkBackground : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // 2 Secondary Action Buttons
                    Row(
                      children: [
                        // Button: XEM KHO 78 LÁ BÀI
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const DeckManagerScreen(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.grid_view_rounded, size: 16, color: gold),
                              label: Text(
                                'KHO 78 LÁ BÀI',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: gold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: gold.withValues(alpha: 0.4), width: 1.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Button: HƯỚNG DẪN SỬ DỤNG
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => HelpGuideScreen(isDark: isDark),
                                  ),
                                );
                              },
                              icon: Icon(Icons.help_outline, size: 16, color: gold),
                              label: Text(
                                'HƯỚNG DẪN',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: gold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: gold.withValues(alpha: 0.4), width: 1.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Feature highlights bullet wrap
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _buildFeatureTag(icon: Icons.palette_outlined, text: '20 Phong Cách', gold: gold, isDark: isDark),
                        _buildFeatureTag(icon: Icons.print_outlined, text: 'Chuẩn In 300 DPI', gold: gold, isDark: isDark),
                        _buildFeatureTag(icon: Icons.auto_awesome, text: 'AI Gemini', gold: gold, isDark: isDark),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTag({
    required IconData icon,
    required String text,
    required Color gold,
    required bool isDark,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: gold.withValues(alpha: 0.8)),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 11,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Đại diện cho bảng màu sắc nhận diện Tarot được người dùng lựa chọn từ Customer Profile.
/// Cung cấp các màu điểm nhấn (accent), gradient nền, viền và surface động cho CardDesignerScreen.
class TarotColorPalette {
  final String name;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final Color darkAccent;
  final Color lightAccent;
  final Color darkSecondaryAccent;
  final Color lightSecondaryAccent;

  const TarotColorPalette({
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.darkAccent,
    required this.lightAccent,
    required this.darkSecondaryAccent,
    required this.lightSecondaryAccent,
  });

  /// Màu điểm nhấn chính có độ tương phản cao, đảm bảo hiển thị rõ ràng trên cả nền tối và sáng.
  Color getAccent(bool isDark) => isDark ? darkAccent : lightAccent;

  /// Màu điểm nhấn phụ cho hiệu ứng đa sắc hoặc shimmer
  Color getSecondaryAccent(bool isDark) => isDark ? darkSecondaryAccent : lightSecondaryAccent;

  /// Gradient nền sang trọng, huyền bí hòa trộn với tông màu người dùng chọn
  LinearGradient getBackgroundGradient(bool isDark) {
    if (isDark) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(AppColors.darkBackground, primaryColor, 0.32)!,
          AppColors.darkBackground,
          Color.lerp(AppColors.darkBackground, secondaryColor, 0.20)!,
        ],
        stops: const [0.0, 0.55, 1.0],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(AppColors.lightBackground, secondaryColor, 0.14)!,
          AppColors.lightBackground,
          Color.lerp(AppColors.lightBackground, primaryColor, 0.08)!,
        ],
        stops: const [0.0, 0.6, 1.0],
      );
    }
  }

  /// Màu nền badge thông tin khách hàng ở trên cùng
  Color getBadgeBackground(bool isDark) {
    return isDark
        ? Color.lerp(AppColors.darkSurfaceVariant, primaryColor, 0.22)!
        : Color.lerp(AppColors.lightSurfaceVariant, secondaryColor, 0.14)!;
  }

  /// Màu viền badge
  Color getBadgeBorder(bool isDark) {
    return getAccent(isDark).withValues(alpha: isDark ? 0.45 : 0.35);
  }

  /// Danh mục 12 bảng màu chủ đạo chuẩn trong Tarot Forge
  static const Map<String, TarotColorPalette> registry = {
    'Vàng Kim & Chàm Tím': TarotColorPalette(
      name: 'Vàng Kim & Chàm Tím',
      description: 'Thần bí & Khai sáng',
      primaryColor: Color(0xFF2A1B3D),
      secondaryColor: Color(0xFFD4AF37),
      darkAccent: Color(0xFFE2C974),
      lightAccent: Color(0xFF8C6D1F),
      darkSecondaryAccent: Color(0xFFB197FC),
      lightSecondaryAccent: Color(0xFF5B2B82),
    ),
    'Đỏ Nhung & Đen Huyền': TarotColorPalette(
      name: 'Đỏ Nhung & Đen Huyền',
      description: 'Quyền năng & Quyến rũ',
      primaryColor: Color(0xFF4A1828),
      secondaryColor: Color(0xFFB33939),
      darkAccent: Color(0xFFE55353),
      lightAccent: Color(0xFF9E1B32),
      darkSecondaryAccent: Color(0xFFFF8787),
      lightSecondaryAccent: Color(0xFF671424),
    ),
    'Xanh Ngọc & Đồng Cổ': TarotColorPalette(
      name: 'Xanh Ngọc & Đồng Cổ',
      description: 'Thanh tao & Cổ xưa',
      primaryColor: Color(0xFF133B3E),
      secondaryColor: Color(0xFFC29B38),
      darkAccent: Color(0xFF38D9A9),
      lightAccent: Color(0xFF0C6B58),
      darkSecondaryAccent: Color(0xFFE5C07B),
      lightSecondaryAccent: Color(0xFF8C6A1A),
    ),
    'Bạc Tinh Tú & Xanh Băng': TarotColorPalette(
      name: 'Bạc Tinh Tú & Xanh Băng',
      description: 'Thanh khiết & Vũ trụ',
      primaryColor: Color(0xFF1B2A4A),
      secondaryColor: Color(0xFF90B4CE),
      darkAccent: Color(0xFF74C0FC),
      lightAccent: Color(0xFF1971C2),
      darkSecondaryAccent: Color(0xFFD0EBFF),
      lightSecondaryAccent: Color(0xFF3B5BDB),
    ),
    'Cam Hoàng Hôn & Nâu Đất': TarotColorPalette(
      name: 'Cam Hoàng Hôn & Nâu Đất',
      description: 'Ấm Áp & Chữa Lành',
      primaryColor: Color(0xFF8B4513),
      secondaryColor: Color(0xFFE07A5F),
      darkAccent: Color(0xFFFF922B),
      lightAccent: Color(0xFFB84A00),
      darkSecondaryAccent: Color(0xFFFFC078),
      lightSecondaryAccent: Color(0xFF7F2D00),
    ),
    'Hồng Phấn & Bạc': TarotColorPalette(
      name: 'Hồng Phấn & Bạc',
      description: 'Dịu Dàng & Mộng Mơ',
      primaryColor: Color(0xFFC0C0C0),
      secondaryColor: Color(0xFFE8A598),
      darkAccent: Color(0xFFFF8FAB),
      lightAccent: Color(0xFFB03A5B),
      darkSecondaryAccent: Color(0xFFE9ECEF),
      lightSecondaryAccent: Color(0xFF862E52),
    ),
    'Tím Than & Xanh Lá Đậm': TarotColorPalette(
      name: 'Tím Than & Xanh Lá Đậm',
      description: 'Bí Ẩn & Sâu Lắng',
      primaryColor: Color(0xFF1E1035),
      secondaryColor: Color(0xFF1B4332),
      darkAccent: Color(0xFFB197FC),
      lightAccent: Color(0xFF5F3DC4),
      darkSecondaryAccent: Color(0xFF69DB7C),
      lightSecondaryAccent: Color(0xFF2B8A3E),
    ),
    'Trắng Ngà & Vàng Nhạt': TarotColorPalette(
      name: 'Trắng Ngà & Vàng Nhạt',
      description: 'Thanh Khiết & Nhẹ Nhàng',
      primaryColor: Color(0xFFF4F1DE),
      secondaryColor: Color(0xFFE9C46A),
      darkAccent: Color(0xFFFFE066),
      lightAccent: Color(0xFF8F6B00),
      darkSecondaryAccent: Color(0xFFFFF3BF),
      lightSecondaryAccent: Color(0xFF664D00),
    ),
    'Đen Tuyền & Đỏ Máu': TarotColorPalette(
      name: 'Đen Tuyền & Đỏ Máu',
      description: 'Quyền Lực & Đam Mê',
      primaryColor: Color(0xFF0D0D0D),
      secondaryColor: Color(0xFF8A0303),
      darkAccent: Color(0xFFFF4D4F),
      lightAccent: Color(0xFFA8071A),
      darkSecondaryAccent: Color(0xFFFF7875),
      lightSecondaryAccent: Color(0xFF5C0011),
    ),
    'Xanh Dương Hoàng Gia & Vàng Đồng': TarotColorPalette(
      name: 'Xanh Dương Hoàng Gia & Vàng Đồng',
      description: 'Uy Nghi & Cổ Kính',
      primaryColor: Color(0xFF0F2042),
      secondaryColor: Color(0xFFD4AF37),
      darkAccent: Color(0xFFFFD43B),
      lightAccent: Color(0xFF1864AB),
      darkSecondaryAccent: Color(0xFF4DABF7),
      lightSecondaryAccent: Color(0xFF8C6D1F),
    ),
    'Xanh Lục Rừng & Nâu Gỗ': TarotColorPalette(
      name: 'Xanh Lục Rừng & Nâu Gỗ',
      description: 'Tự Nhiên & Vững Chãi',
      primaryColor: Color(0xFF2D5A27),
      secondaryColor: Color(0xFF5C4033),
      darkAccent: Color(0xFF51CF66),
      lightAccent: Color(0xFF237804),
      darkSecondaryAccent: Color(0xFFB58900),
      lightSecondaryAccent: Color(0xFF43281C),
    ),
    'Cầu Vồng Ánh Kim & Trắng': TarotColorPalette(
      name: 'Cầu Vồng Ánh Kim & Trắng',
      description: 'Huyền Ảo & Đa Sắc',
      primaryColor: Color(0xFF9D4EDD),
      secondaryColor: Color(0xFF5BC0BE),
      darkAccent: Color(0xFFDA77F2),
      lightAccent: Color(0xFF862E9C),
      darkSecondaryAccent: Color(0xFF3BC9DB),
      lightSecondaryAccent: Color(0xFF0B7285),
    ),
  };

  /// Tra cứu bảng màu theo tên gọi tiếng Việt, tự động fallback về 'Vàng Kim & Chàm Tím' nếu không khớp.
  static TarotColorPalette fromName(String? name) {
    if (name == null || name.isEmpty) {
      return registry['Vàng Kim & Chàm Tím']!;
    }
    return registry[name] ?? registry['Vàng Kim & Chàm Tím']!;
  }
}

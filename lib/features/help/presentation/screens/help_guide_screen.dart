import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// In-app usage guide for Tarot Forge Phase 1.
class HelpGuideScreen extends StatelessWidget {
  final bool isDark;

  const HelpGuideScreen({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final gold = isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          'HƯỚNG DẪN SỬ DỤNG',
          style: AppTypography.screenTitle(isDark: isDark),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(
            'Tarot Forge là công cụ tự thiết kế lá bài Tarot của riêng bạn — '
            'nhập thông tin & sở thích của khách, chọn khung viền, viết nội '
            'dung, chọn hoặc tạo hình minh họa bằng AI, rồi xuất ra file PDF '
            'chuẩn in ấn thật. Bản demo hiện tại thiết kế được 1 lá bài tại '
            'một thời điểm.',
            style: AppTypography.body(isDark: isDark, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _SpecTag(text: '70 × 120 MM'),
              _SpecTag(text: 'BLEED 3 MM'),
              _SpecTag(text: '300 DPI'),
              _SpecTag(text: '4 MẪU KHUNG'),
              _SpecTag(text: '20 PHONG CÁCH'),
              _SpecTag(text: '12 TÔNG MÀU'),
            ],
          ),
          const SizedBox(height: 28),

          _StepTile(
            number: 1,
            title: 'Nhập thông tin khách hàng',
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đây là màn hình đầu tiên khi mở app. Nhập tên khách hàng, '
                  'chọn 1 trong 20 PHONG CÁCH NGHỆ THUẬT yêu thích (Huyền '
                  'Bí, Cổ Điển, Gothic, Ai Cập, Thiên Hà, Cyberpunk...), '
                  'chọn 1 trong 12 TÔNG MÀU SẮC chủ đạo, và CHỦ ĐỀ HÌNH '
                  'TƯỢNG mong muốn. Đổi phong cách hoặc đổi màu đều sẽ cho '
                  'ra lá bài gợi ý khác nhau — không bị lặp lại y hệt nhau.',
                  style: AppTypography.body(isDark: isDark, fontSize: 13.5),
                ),
                const SizedBox(height: 6),
                Text(
                  'Mục GHI CHÚ & TÂM NIỆM RIÊNG chỉ có tác dụng khi bạn đã '
                  'lưu API key Gemini (xem Bước 4) — app dùng đúng nội dung '
                  'bạn ghi làm mô tả để AI vẽ ảnh, nên nên ghi mô tả hình '
                  'ảnh mong muốn thay vì ghi chú thông thường.',
                  style: AppTypography.body(isDark: isDark, fontSize: 12.5),
                ),
                const SizedBox(height: 6),
                Text(
                  'Bấm BẮT ĐẦU THIẾT KẾ BÀI — app tự gợi ý mẫu khung + lá '
                  'bài phù hợp với phong cách/màu vừa chọn. Nếu đã có API '
                  'key, app còn tự gọi AI vẽ luôn ảnh minh họa riêng cho lá '
                  'đó (hiện màn hình "Đang triệu hồi Gemini AI" trong lúc '
                  'chờ, có thể bấm bỏ qua nếu muốn vào thiết kế ngay).',
                  style: AppTypography.body(isDark: isDark, fontSize: 12.5),
                ),
              ],
            ),
          ),

          _StepTile(
            number: 2,
            title: 'Chọn mẫu khung lá bài',
            isDark: isDark,
            child: Text(
              'Thanh cuộn ngang phía dưới màn hình chính có 4 phong cách '
              'khung viền — chạm để chọn, lá bài ở giữa cập nhật ngay lập '
              'tức: Cổ Điển Huyền Bí, Thiên Thể Huyền Diệu, Giả Kim Tối '
              'Giản, Nghệ Thuật Toàn Khung. Bấm vào thanh "Bộ bài: ..." ở '
              'trên cùng nếu muốn quay lại sửa hồ sơ khách hàng.',
              style: AppTypography.body(isDark: isDark, fontSize: 13.5),
            ),
          ),

          _StepTile(
            number: 3,
            title: 'Viết nội dung lá bài',
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bấm nút VĂN BẢN ở thanh công cụ dưới cùng để mở bảng '
                  'chỉnh sửa:',
                  style: AppTypography.body(isDark: isDark, fontSize: 13.5),
                ),
                const SizedBox(height: 10),
                _FieldRow(label: 'SỐ LA MÃ', desc: 'VD: XVII, 0, I, IX', isDark: isDark, gold: gold),
                _FieldRow(label: 'TÊN LÁ BÀI', desc: 'VD: NGÔI SAO, KẺ NGỐC', isDark: isDark, gold: gold),
                _FieldRow(label: 'TỪ KHÓA', desc: 'VD: Hy Vọng • Cảm Hứng', isDark: isDark, gold: gold),
                const SizedBox(height: 4),
                Text(
                  'Mục MẪU CÓ SẴN cho 3 lá dựng sẵn để điền nhanh, chỉnh lại tùy ý.',
                  style: AppTypography.body(isDark: isDark, fontSize: 12.5),
                ),
              ],
            ),
          ),

          _StepTile(
            number: 4,
            title: 'Chọn hoặc tạo hình minh họa bằng AI',
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bấm nút HÌNH ẢNH để mở 3 lựa chọn:',
                  style: AppTypography.body(isDark: isDark, fontSize: 13.5),
                ),
                const SizedBox(height: 8),
                _FieldRow(label: 'THƯ VIỆN', desc: 'Chọn nhanh từ tranh Major Arcana có sẵn.', isDark: isDark, gold: gold),
                _FieldRow(label: 'TẢI TỪ MÁY', desc: 'Dùng ảnh riêng PNG, JPG, WEBP độ phân giải cao.', isDark: isDark, gold: gold),
                _FieldRow(label: 'TẠO BẰNG AI', desc: 'Gõ mô tả, AI (Gemini) vẽ ảnh Tarot riêng cho lá bài.', isDark: isDark, gold: gold),
                const SizedBox(height: 10),
                Text(
                  'Để dùng TẠO BẰNG AI: lần đầu app sẽ hỏi API key Gemini — '
                  'lấy miễn phí tại aistudio.google.com, dán vào ô rồi bấm '
                  'LƯU (key chỉ lưu trên máy/trình duyệt của bạn, không gửi '
                  'lên đâu khác). Sau đó gõ mô tả ý tưởng (VD: "Nữ hoàng '
                  'ngồi trên ngai vàng giữa rừng hoa hồng") và bấm TẠO ẢNH '
                  'BẰNG AI (GEMINI). App sẽ tự ghép thêm phong cách/màu '
                  'sắc/chủ đề đã chọn ở Bước 1 để AI luôn vẽ đúng phong '
                  'cách bài Tarot, không lạc sang phong cách khác. Ưng ý '
                  'thì bấm SỬ DỤNG ẢNH NÀY, chưa ưng thì bấm TẠO LẠI.',
                  style: AppTypography.body(isDark: isDark, fontSize: 12.5),
                ),
              ],
            ),
          ),

          _StepTile(
            number: 5,
            title: 'Xuất file in PDF',
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bấm biểu tượng PDF trên thanh tiêu đề hoặc nút XUẤT FILE '
                  '— bảng thông số in ấn hiện ra: 70×120mm, bleed 3mm, 300 '
                  'DPI, có thể bật/tắt dấu cắt in ấn.',
                  style: AppTypography.body(isDark: isDark, fontSize: 13.5),
                ),
                const SizedBox(height: 6),
                Text(
                  'XEM TRƯỚC & IN PDF để in trực tiếp, hoặc LƯU / CHIA SẺ '
                  'FILE PDF để tải file gửi nhà in.',
                  style: AppTypography.body(isDark: isDark, fontSize: 12.5),
                ),
              ],
            ),
          ),

          _StepTile(
            number: 6,
            title: 'Xoay xem 3D & đổi giao diện',
            isDark: isDark,
            child: Text(
              'Kéo hoặc di chuột trên lá bài ở giữa màn hình để xem hiệu '
              'ứng nghiêng 3D. Bấm biểu tượng mặt trời / mặt trăng ở góc '
              'trên bên phải để chuyển giữa giao diện sáng và tối.',
              style: AppTypography.body(isDark: isDark, fontSize: 13.5),
            ),
          ),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: gold.withValues(alpha: 0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: gold),
                    const SizedBox(width: 8),
                    Text('ĐÂY LÀ BẢN DEMO PHASE 1', style: AppTypography.sectionHeader(isDark: isDark)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Chưa có trong bản này, sẽ bổ sung sau: quản lý trọn bộ '
                  '78 lá cùng lúc, tài khoản đăng nhập & đồng bộ nhiều '
                  'thiết bị, gói trả phí / mua credit AI. Mỗi lần gọi tạo '
                  'ảnh AI dùng hạn mức miễn phí của chính API key bạn nhập.',
                  style: AppTypography.body(isDark: isDark, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecTag extends StatelessWidget {
  final String text;
  const _SpecTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final gold = isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: gold.withValues(alpha: 0.4)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 10.5,
            letterSpacing: 0.6,
            fontWeight: FontWeight.w600,
            color: gold,
          ),
        ),
      );
    });
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final String desc;
  final bool isDark;
  final Color gold;

  const _FieldRow({
    required this.label,
    required this.desc,
    required this.isDark,
    required this.gold,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: gold,
              ),
            ),
          ),
          Expanded(
            child: Text(desc, style: AppTypography.body(isDark: isDark, fontSize: 12.5)),
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final int number;
  final String title;
  final bool isDark;
  final Widget child;

  const _StepTile({
    required this.number,
    required this.title,
    required this.isDark,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final gold = isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: gold,
            ),
            child: Text(
              '$number',
              style: TextStyle(
                fontFamily: 'Cinzel',
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: isDark ? AppColors.darkBackground : Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    letterSpacing: 0.5,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

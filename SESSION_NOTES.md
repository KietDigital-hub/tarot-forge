# Session Notes — Tarot Forge

Đọc file này để nắm nhanh bối cảnh, khỏi phải hỏi lại từ đầu.

## Bối cảnh

- Dự án: app Flutter "Tarot Forge" — user tự thiết kế bộ bài Tarot, export
  printable high-res PDF, thu phí kiểu freemium + credit pack + subscription.
- Kế hoạch đầy đủ nằm ở [PLAN.md](PLAN.md) — đọc file đó để biết chi tiết
  tính năng, tech stack, roadmap 4 phase.
- **Code thực tế được viết trong Google Antigravity IDE** (ứng dụng desktop
  riêng, không phải trong session Claude Code này). Claude Code (tôi) đóng
  vai trò tư vấn, chuẩn bị môi trường, viết prompt cho Antigravity, và debug
  khi user gặp lỗi.

## Trạng thái môi trường

- Flutter SDK cài tại `D:\flutter` (stable, đã vào PATH). `flutter doctor` OK.
- Android SDK / Android Studio: CHƯA cài (cài khi cần test emulator/máy thật):
  `winget install -e --id Google.AndroidStudio --accept-package-agreements --accept-source-agreements`
- iOS: không build được trên máy Windows này (cần Mac/Xcode) — giới hạn cứng.
- Gemini API key: chưa lấy (user cần tự lấy ở aistudio.google.com).
- Repo git: nhánh `main`, đã có remote origin, user GitHub: KietDigital-hub.

## Tiến độ

- **Phase 1 (Card Designer + export PDF) — ĐÃ XONG.**
  Chuẩn lá bài: 70x120mm (Rider-Waite), bleed 3mm, 300 DPI, có crop marks.
  Dùng `flutter_riverpod` (state) + `pdf` (export). 4 template: Classic
  Arcana, Celestial Mystic, Minimalist Alchemy, Full-Bleed Art.
  Code nằm ở `lib/features/card_designer/` (models, provider, screen,
  canvas preview, text editor, export sheet, image picker, template bar,
  pdf_export_service).
- Đã thêm: màn hình hướng dẫn sử dụng trong app (`lib/features/help/`,
  mở từ icon help), và dịch toàn bộ UI sang tiếng Việt.
- **Phase 2 (AI generate ảnh qua Gemini + quản lý bộ 78 lá) — CHƯA BẮT ĐẦU.**
  Chưa có Firebase, chưa có Gemini, chưa có màn hình quản lý deck 78 lá.
- Phase 3 (monetization) và Phase 4 (polish) — chưa bắt đầu.

## Việc cần làm tiếp (khi mở session mới)

1. Hỏi user muốn tiếp tục Phase 2 (AI generate + deck 78 lá) hay còn việc gì
   ở Phase 1 cần sửa/polish trước.
2. Nếu bắt đầu Phase 2: cần Gemini API key (nhắc user lấy nếu chưa có) +
   quyết định có cần Firebase ngay không hay demo trước bằng local storage.
3. Nếu user báo lỗi từ Antigravity → đọc log/error user gửi, debug giúp.
4. Cài Android Studio nếu user muốn test trên thiết bị Android thật.

## Lưu ý về git

- Có 3 file build tự sinh đang bị track và luôn hiện modified:
  `windows/flutter/generated_plugin_registrant.{cc,h}` và
  `generated_plugins.cmake`. Vô hại (CMake tự ghi lại khi build) — có thể
  bỏ qua hoặc thêm vào `.gitignore` nếu thấy phiền.

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

## Trạng thái môi trường (đã setup xong)

- Flutter SDK đã cài tại `D:\flutter` (stable channel, đã thêm vào User PATH).
  `flutter doctor` chạy OK: Flutter/Chrome/Windows desktop sẵn sàng.
- **Android SDK / Android Studio: CHƯA cài** (user yêu cầu huỷ lúc đang tải,
  để cài sau khi cần test trên emulator/điện thoại Android thật). Cài bằng
  `winget install -e --id Google.AndroidStudio --accept-package-agreements
  --accept-source-agreements` khi cần.
- iOS: không build được trên máy Windows này (cần Mac/Xcode) — giới hạn cứng.
- Gemini API key: chưa lấy (user cần tự vào aistudio.google.com lấy, cần
  đăng nhập Google nên Claude không lấy hộ được).

## Tiến độ Phase 1 (trong Antigravity)

- Đã gửi prompt xây dựng "Tarot Forge" Phase 1 (Card Designer 1 lá bài +
  export PDF 300dpi/bleed 3mm) cho Antigravity agent.
- Agent đã trả lời bằng 1 implementation plan, hỏi 3 câu — đã được user
  duyệt: dùng flutter_riverpod, làm cả 4 template (Classic Arcana, Celestial
  Mystic, Minimalist Alchemy, Full-Bleed Art), có crop marks khi export PDF.
  Đã gửi câu trả lời/approval đó lại cho Antigravity, agent đang/sẽ code.
- Chuẩn Tarot card đã chốt: 70x120mm (Rider-Waite), bleed 3mm, 300 DPI.

## Việc cần làm tiếp (khi mở session mới)

1. Hỏi user: Antigravity đã code xong Phase 1 chưa, có lỗi gì không.
2. Nếu có lỗi/vướng mắc từ Antigravity → đọc log/error user gửi, debug giúp.
3. Nếu Phase 1 xong và chạy được → chuyển sang Phase 2 (AI generate ảnh qua
   Gemini + quản lý bộ 78 lá) theo roadmap trong PLAN.md.
4. Nhắc user lấy Gemini API key nếu tới lúc cần (Phase 2).
5. Cài Android Studio nếu user muốn test trên thiết bị Android thật.

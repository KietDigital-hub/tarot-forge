# TAROT FORGE — CONTEXT TỐI ƯU CHO SESSION MỚI

> **Mục đích**: File này lưu trữ toàn bộ trạng thái kỹ thuật và tiến độ của dự án Tarot Forge dưới dạng cô đọng nhất. Khi mở session mới, Agent chỉ cần đọc file này là nắm bắt 100% dự án mà không tốn token lịch sử trò chuyện cũ.

---

## 1. TỔNG QUAN DỰ ÁN
- **Tên app**: Tarot Forge
- **Mục tiêu**: Ứng dụng thiết kế bài Tarot tùy biến cao cấp và xuất file PDF/ảnh chuẩn in ấn công nghiệp (Print-Ready 300 DPI, 3mm bleed, crop marks).
- **Ngôn ngữ & Giao diện**: 100% Tiếng Việt, Dark Mystic Theme (Gold #D4AF37, Obsidian #0D0D0D, Velvet #1A1A24), phông chữ Cinzel & Outfit.
- **Tech Stack**:
  - Flutter 3.38+ (Dart 3.7+)
  - Quản lý trạng thái: `flutter_riverpod` (v2.6.1)
  - Lưu trữ cục bộ: `shared_preferences`
  - Tạo file in ấn: `pdf` (v3.11.1), `printing`, `image`
  - AI Image Generation: Tích hợp trực tiếp Google Gemini API (`gemini-2.5-flash` / `imagen-3.0`)
  - Chạy thử nghiệm: Web Server `http://localhost:8080` + Cloudflare Tunnel.

---

## 2. KIẾN TRÚC & SƠ ĐỒ FILE QUAN TRỌNG

```
d:\vibe code app\
├── lib/
│   ├── main.dart                                        # Điểm khởi động, ProviderScope, định tuyến ban đầu -> HomeScreen
│   ├── core/
│   │   ├── constants/
│   │   │   ├── tarot_constants.dart                     # Tỉ lệ chuẩn 70x120mm, 300 DPI, 3mm bleed, crop marks
│   │   │   ├── tarot_deck_data.dart                     # Preset mẫu ban đầu
│   │   │   └── tarot_78_cards_data.dart                 # [PHASE 2] Cơ sở dữ liệu 78 lá bài đầy đủ (22 Major + 56 Minor)
│   │   ├── services/
│   │   │   ├── gemini_api_key_store.dart                # Lưu & tải API Key thiết bị
│   │   │   └── gemini_image_service.dart                # Gọi Gemini REST API sinh ảnh lá bài
│   │   ├── theme/
│   │   │   ├── app_colors.dart                          # Bảng màu vàng kim + đen nhung
│   │   │   ├── app_theme.dart                           # Light & Dark theme
│   │   │   └── app_typography.dart                      # Cinzel & Outfit typography
│   │   └── widgets/
│   │       ├── mystic_particles.dart                    # Hiệu ứng hạt bụi vàng & sao 4 cánh trôi lơ lửng
│   │       ├── ornate_tarot_frame.dart                  # Khung viền kim loại hoa văn cổ điển 4 phong cách
│   │       ├── gold_shimmer_border.dart                 # Viền ánh kim phản chiếu
│   │       ├── tilt_card_container.dart                 # Con quay hồi chuyển / chuột nghiêng 3D
│   │       └── card_back_painter.dart                   # [PHASE 2] Vector CustomPainter vẽ họa tiết mặt sau đối xứng
│   ├── features/
│   │   ├── home/                                        # [TRANG CHỦ MỚI] Điểm vào đầu tiên của app
│   │   │   └── presentation/screens/home_screen.dart    # Giới thiệu app, Hero card 3D, nút lớn bắt đầu thiết kế, 2 nút phụ kho bài & hướng dẫn
│   │   ├── customer_profile/                            # BƯỚC 1: Hồ sơ khách hàng (Thiết kế lại trải nghiệm: Đơn giản trước, nâng cao sau)
│   │   │   ├── domain/models/customer_profile.dart      # 20 Phong cách + 12 Bảng màu + Gemini prompt + Recommendation Engine
│   │   │   ├── presentation/providers/customer_profile_provider.dart
│   │   │   └── presentation/screens/customer_profile_screen.dart # 6 Gợi ý phổ biến dạng thẻ lớn (gộp sẵn màu), Tùy chỉnh nâng cao thu gọn
│   │   ├── card_designer/                               # BƯỚC 2: Thiết kế lá bài & lật mặt 3D
│   │   │   ├── domain/models/
│   │   │   │   ├── card_back_design.dart                # [PHASE 2] Model cấu hình mặt sau lá bài
│   │   │   │   ├── card_template.dart                   # Định nghĩa 4 templates khung viền
│   │   │   │   └── tarot_card.dart                      # Model lá bài (suit, number, element, name, ảnh, viền...)
│   │   │   ├── presentation/providers/card_designer_provider.dart # Quản lý activeCard, cardFlip, cardBack
│   │   │   ├── presentation/screens/card_designer_screen.dart    # Canvas 3D tilt & flip preview, duyệt lá (< >)
│   │   │   ├── presentation/widgets/
│   │   │   │   ├── card_canvas_preview.dart             # Canvas mặt trước lá bài với bleed/trim thực tế
│   │   │   │   ├── card_back_preview.dart               # [PHASE 2] Widget xem trước mặt sau lá bài
│   │   │   │   ├── card_back_editor_sheet.dart          # [PHASE 2] Sheet tùy chỉnh họa tiết & màu sắc mặt sau
│   │   │   │   ├── template_selector_bar.dart           # 4 Templates viền
│   │   │   │   ├── image_picker_sheet.dart              # Chọn ảnh có sẵn / upload / gọi AI
│   │   │   │   ├── card_text_editor_sheet.dart          # Chỉnh sửa chữ, tên, số La Mã
│   │   │   │   └── export_action_sheet.dart             # [PHASE 2] Xuất PDF đơn lẻ hoặc hàng loạt trọn bộ
│   │   │   └── services/
│   │   │       └── pdf_export_service.dart              # [PHASE 2] Engine xuất PDF 300 DPI, Bleed 3mm, Duplex in 2 mặt
│   │   ├── deck_manager/                                # BƯỚC 3: Quản lý trọn bộ 78 lá bài
│   │   │   ├── domain/models/tarot_deck.dart            # Model bộ bài 78 lá, tiến độ hoàn thành, bộ lọc
│   │   │   ├── presentation/providers/deck_provider.dart # Notifier quản lý trọn bộ bài & activeCardId
│   │   │   ├── presentation/screens/deck_manager_screen.dart # Duyệt lưới 78 lá, tìm kiếm, lọc theo chất
│   │   │   └── widgets/
│   │   │       ├── deck_progress_card.dart              # Thẻ hiển thị tiến độ hoàn thiện bộ bài
│   │   │       └── mini_card_tile.dart                  # Thẻ bài thu nhỏ trong danh sách với huy hiệu trạng thái
│   │   └── help/                                        # Hướng dẫn sử dụng
│   │       └── presentation/screens/help_guide_screen.dart
│   test/
│   ├── home_screen_widget_test.dart                     # 4 tests UI & điều hướng màn hình Home
│   ├── customer_profile_test.dart                       # 9 tests logic recommendation, palette & prompt
│   ├── customer_flow_widget_test.dart                   # 8 tests luồng UI từ Bước 1 sang Bước 2 & palette
│   ├── export_sample_pdf_test.dart                      # 4 tests tạo PDF vật lý kiểm tra
│   ├── widget_test.dart                                 # 1 test prepress generator
│   ├── deck_manager_test.dart                           # 11 tests trọn bộ 78 lá & DeckNotifier
│   ├── card_back_test.dart                              # 5 tests model mặt sau & CustomPainter
│   ├── batch_pdf_export_test.dart                       # 2 tests xuất PDF hàng loạt & in 2 mặt Duplex
│   └── deck_manager_flow_widget_test.dart               # 2 tests UI luồng duyệt bộ bài
└── PLAN.md                                              # Lộ trình tổng thể dự án từ Phase 1 đến Phase 4
```

---

## 3. CÁC TÍNH NĂNG ĐÃ HOÀN THIỆN
1. **Màn Hình Trang Chủ Mới (Home Screen)**:
   - Thay thế vị trí khởi đầu (`home:` trong `main.dart`).
   - Tiêu đề "TAROT FORGE" + Tagline chuẩn xác: *"Tự thiết kế bộ bài Tarot của riêng bạn, chuẩn in ấn chuyên nghiệp"*.
   - Khối minh họa Hero Card 3D nghiêng (`TiltCardContainer`) với viền ánh kim lấp lánh (`GoldShimmerBorder`), hiệu ứng hạt huyền bí (`MysticParticlesOverlay`).
   - Nút hành động chính nổi bật: **"BẮT ĐẦU THIẾT KẾ BỘ BÀI MỚI"** (với hiệu ứng hào quang vàng thở) -> dẫn vào `CustomerProfileScreen`.
   - 2 nút hành động phụ: **"KHO 78 LÁ BÀI"** (vào `DeckManagerScreen`) và **"HƯỚNG DẪN"** (vào `HelpGuideScreen`).
   - Tích hợp nút chuyển đổi giao diện Sáng / Tối trực tiếp trên thanh AppBar.
2. **Thiết Kế Lại Trải Nghiệm Màn Hình Nhập Hồ Sơ (Customer Profile)**:
   - Áp dụng triết lý *"Đơn giản trước, nâng cao sau"*:
     - **Gợi ý 6 phong cách phổ biến dạng thẻ lớn (2 cột)**: Huyền bí, Cổ điển, Hoàng gia, Thiên nhiên, Tối giản, Gothic tối. Mỗi thẻ gộp sẵn 1 bảng màu tương thích cao nhất, có hình minh họa lá bài mẫu thực tế, icon, nhãn màu và dấu tích xanh khi được chọn. Người dùng mới chỉ cần chạm 1 lần là chọn xong cả phong cách và màu sắc.
     - **Huy hiệu tóm tắt trạng thái**: Hiện rõ ràng *"Đang chọn: [Phong cách] • [Tông màu]"*.
     - **Tùy chỉnh nâng cao (Collapsible)**: Nút bật/tắt thu gọn mặc định. Khi người dùng muốn tinh chỉnh chuyên sâu, bấm vào sẽ xổ ra toàn bộ 20 phong cách nghệ thuật, 12 bảng màu chủ đạo, 5 chủ đề hình tượng và ô nhập Ghi chú & Tâm niệm riêng.
     - Giữ nguyên 100% logic ngầm: `suggestedTemplateId`, `suggestedPreset`, `palette`, `accentColor`, `buildTarotPrompt`.
3. **Quản Lý Trọn Bộ 78 Lá Bài (Deck Manager)**:
   - Toàn bộ 78 lá bài chuẩn hệ thống Rider-Waite:
     - 22 lá Ẩn chính (Major Arcana từ 0 - Kẻ Khờ đến XXI - Thế Giới).
     - 56 lá Ẩn phụ (Minor Arcana: 14 Gậy 🔥, 14 Chén 💧, 14 Kiếm 💨, 14 Tiền 🌍).
   - Bộ lọc danh mục tức thì: Tất Cả (78), Ẩn Chính (22), Gậy (14), Chén (14), Kiếm (14), Tiền (14), Đã Tùy Biến.
   - Tìm kiếm thời gian thực theo tên tiếng Việt, số La Mã, từ khóa.
   - Thẻ hiển thị tiến độ hoàn thiện (ví dụ: `8 / 78 lá • 10%`) kèm thanh progress bar vàng kim.
   - Chạm vào bất kỳ lá nào trong danh sách để mở ngay vào Card Designer.
4. **Màn Hình Thiết Kế Lá Bài (Card Designer & 3D Flip)**:
   - Canvas 3D tilt phản hồi chuột/chạm.
   - **Hiệu ứng Lật 3D (Flip Card 180°)**: Chuyển đổi mượt mà giữa Mặt Trước và Mặt Sau với chiều sâu không gian 3D.
   - Điều hướng lá bài trực tiếp (< >): Chuyển nhanh giữa các lá bài trong bộ mà không cần thoát ra ngoài.
   - Đổi template, chỉnh sửa tên lá, số La Mã, mô tả phụ.
   - Tích hợp Gemini AI tạo ảnh từ prompt kết hợp sở thích hồ sơ khách hàng.
5. **Thiết Kế Mặt Sau Lá Bài (Card Back Designer)**:
   - 4 bộ hoa văn vector đối xứng tuyệt đối (không lộ chiều xuôi/ngược khi bốc bài):
     1. `Hoa Sự Sống (Sacred Geometry)`: Mạng lưới hình học thiêng liêng.
     2. `La Bàn Thiên Thể (Celestial Compass)`: Sao 8 cánh, 4 vầng trăng khuyết và tinh tú.
     3. `Ấn Ký Ouroboros (Alchemical Ouroboros)`: Rắn cắn đuôi vĩnh cửu và ấn ký 4 nguyên tố.
     4. `Nhật Nguyệt Đối Xứng (Mystic Sun & Moon)`: Mặt trời tỏa rạng giao hòa vầng trăng hai đầu.
     5. `Tranh Tùy Biến (Custom Art / AI)`: Hỗ trợ upload ảnh riêng hoặc tạo tranh AI cho mặt sau.
   - Tùy chỉnh màu nền giấy huyền bí và màu nhũ kim loại (Vàng hoàng kim, Bạc tinh tú, Đồng cổ, Hồng thạch anh).
6. **Xuất File In Ấn Công Nghiệp Hàng Loạt (Batch Prepress Engine)**:
   - Xuất PDF Vector 300 DPI, khổ Rider-Waite 70 x 120 mm + 3mm bleed mỗi cạnh (76 x 126 mm) và Crop Marks 4 góc.
   - **Tùy chọn phạm vi xuất**: Lá hiện tại (1 lá), Bộ Ẩn chính (22 lá), Các lá đã tùy biến, hoặc Trọn bộ bài (78 lá).
   - **Tùy chọn In Hai Mặt (Duplex)**: Tự động ghép trang mặt trước và trang mặt sau tương ứng, sẵn sàng nạp trực tiếp vào máy in 2 mặt hoặc xưởng in công nghiệp offset/laser.

---

## 4. TÌNH TRẠNG KIỂM THỬ
- **`flutter analyze`**: **0 lỗi / 0 cảnh báo / 0 info** (100% clean).
- **`flutter test`**: **46/46 tests PASSED** (toàn bộ 9 file test đều xanh).

---

## 5. LỘ TRÌNH TIẾP THEO (GỢI Ý CHO SESSION TIẾP THEO)
Tùy nhu cầu phát triển tiếp, có thể chọn:
1. **Thiết kế Hộp Đựng Bài (Card Box / Tuck Box Designer)**: Tạo bản vẽ khuôn bế (Die-cut template) hộp đựng bài Tarot chuẩn 78 lá có nắp gài, xuất file PDF in hộp đồng bộ hoa văn với bộ bài.
2. **Sách Hướng Dẫn Kèm Theo (Guidebook / Little White Book Generator)**: Xuất cẩm nang giải nghĩa ý nghĩa 78 lá bài (chiều xuôi & chiều ngược) theo định dạng booklet mini.
3. **Đồng bộ Đám Mây (Cloud Sync & Auth)**: Tích hợp Firebase Auth và Cloud Firestore để lưu nhiều bộ bài theo tài khoản người dùng.
4. **Hệ thống Thu phí & Gói cước (Monetization & Paywall)**: Tích hợp RevenueCat / StoreKit để bán gói credit tạo ảnh AI và gói xuất bản Pro không watermark.

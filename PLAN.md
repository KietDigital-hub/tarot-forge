# Tarot Forge — Kế hoạch dự án (Demo)

> App cho phép người dùng tự thiết kế bộ bài Tarot của riêng mình (AI generate hoặc upload ảnh), xuất file printable high-res, và có hệ thống thu phí kết hợp (freemium + credit pack + subscription).

Trạng thái: **Demo / chưa có ngân sách** — mục tiêu là chứng minh ý tưởng (proof of concept), chưa tối ưu chi phí vận hành thật.

---

## 1. Ý tưởng & giá trị cốt lõi

- **Ngách**: Tarot — cộng đồng người hành nghề/tin Tarot, người mê nghệ thuật/tâm linh.
- **USP**: không chỉ là app đọc bài Tarot thông thường — cho phép tạo ra **sản phẩm vật lý thật** (bộ bài in được), cá nhân hóa hoàn toàn.
- Người dùng tự thiết kế từng lá (Major + Minor Arcana), dùng AI vẽ minh họa hoặc upload ảnh riêng, rồi xuất file chuẩn in ấn (300dpi, đúng kích thước, có bleed).

## 2. Đối tượng người dùng

- Người hành nghề Tarot muốn bộ bài cá nhân hóa cho khách hàng/bản thân.
- Họa sĩ/người sáng tạo muốn tự làm bộ bài nghệ thuật.
- Người mê tâm linh muốn quà tặng/sưu tầm độc bản.

## 3. Nền tảng & Tech stack

| Thành phần | Lựa chọn | Lý do |
|---|---|---|
| Client | **Flutter (Dart)** | Cross-platform Android + iOS từ 1 codebase, miễn phí, phù hợp demo trên cả 2 nền tảng |
| Backend | **Firebase** (Auth, Firestore, Storage, Cloud Functions) | Free tier đủ cho demo, không cần tự vận hành server |
| AI image generation | **Gemini API** (image generation) | Free quota để demo, gọi qua Cloud Function để giấu API key |
| Export in ấn | Xử lý layout/PDF phía client (thư viện `pdf`, `image` trong Dart) | Canvas kích thước chuẩn lá Tarot, xuất PNG 300dpi / PDF có bleed |
| In-app Purchase | RevenueCat (hoặc Google Play Billing / StoreKit trực tiếp) | Quản lý subscription + one-time purchase đa nền tảng |
| AI coding assistant | Google Antigravity | Hỗ trợ sinh code Flutter/Dart theo hướng agentic |

## 4. Tính năng theo module

### A. Card Designer
- Chọn layout lá bài (khung viền, font tên lá, vị trí số La Mã)
- Thêm ảnh nền: AI generate hoặc upload
- Chỉnh sửa cơ bản: crop, filter, text overlay

### B. AI Image Generation
- Nhập prompt mô tả → Gemini tạo ảnh minh họa cho từng lá
- Giữ style nhất quán giữa các lá trong cùng bộ (style reference/seed)

### C. Deck Management
- Quản lý bộ 78 lá (Major + Minor Arcana)
- Tạo nhiều bộ, lưu nháp

### D. Export in ấn (Printable High-Res)
- Xuất PDF/PNG 300dpi, đúng kích thước chuẩn bài Tarot + bleed 3mm
- Sắp xếp layout in hàng loạt (imposition) cho in tại nhà hoặc gửi nhà in

### E. Monetization / Paywall
- **Free**: thiết kế không giới hạn, export có watermark, giới hạn X lượt AI generate/tháng
- **Credit pack**: mua thêm lượt AI generate khi hết free quota (one-time)
- **Subscription (Pro)**: export không watermark, unlimited high-res export, AI quota cao hơn/tháng
- **Pay-per-export**: trả 1 lần để xuất 1 bộ bài high-res không watermark (không cần sub)

### F. Account & lưu trữ
- Đăng nhập Google/Apple/email
- Đồng bộ bộ bài qua cloud

## 5. Kiến trúc kỹ thuật

```
Flutter App (Android/iOS)
   ├── Firebase Auth (đăng nhập)
   ├── Firestore (metadata bộ bài, user, quota)
   ├── Firebase Storage (ảnh lá bài)
   ├── Gemini API (AI generate ảnh) — qua Cloud Function
   ├── Local PDF/Image rendering (export high-res)
   └── In-app Purchase (RevenueCat / Play Billing / StoreKit)
```

## 6. Roadmap

- **Phase 1 — Demo core**: Card Designer cơ bản (1 lá bài, chọn layout + upload ảnh) + export thử 1 file PDF high-res. Chưa cần AI, chưa cần thanh toán.
- **Phase 2 — AI + Deck**: Thêm AI generate ảnh (Gemini), quản lý bộ 78 lá.
- **Phase 3 — Monetization**: Hệ thống quota/paywall + in-app purchase (subscription + credit pack + pay-per-export).
- **Phase 4 — Polish**: UI hoàn thiện, đồng bộ cloud, chuẩn bị launch thật (khi có ngân sách).

## 7. Câu hỏi / rủi ro còn mở

- Chuẩn kích thước bài Tarot cụ thể (Rider-Waite 70x120mm hay Bridge size) — cần chốt trước Phase 1.
- Có tích hợp nhà in đối tác (API gửi file in trực tiếp) hay chỉ xuất file để user tự lo?
- Chi phí Gemini image API có thể vượt free tier nếu nhiều user demo cùng lúc — cần theo dõi khi test.

## 8. Bước tiếp theo

Bắt đầu **Phase 1**: dựng khung project Flutter, màn hình Card Designer đơn giản, export thử 1 lá bài ra PDF 300dpi.

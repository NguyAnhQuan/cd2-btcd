# cd2btcd — Ứng dụng nhật ký (Flutter)

Ứng dụng di động đa nền tảng (Android, iOS, Windows, …) để **ghi nhật ký**, xem danh sách, **sắp xếp/lọc**, **xóa**, đính kèm **ảnh từ URL**, và **nhắc nhở theo lịch** (thông báo cục bộ). Dữ liệu nhật ký được **lưu file JSON** trong thư mục dữ liệu của app.

## Yêu cầu môi trường

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (khuyến nghị bản ổn định mới nhất)
- Dart SDK **^3.11.3** (đi kèm Flutter)
- Thiết bị/emulator hoặc máy để chạy (Windows desktop, Chrome, Android, iOS tùy cấu hình)

Kiểm tra:

```bash
flutter doctor
```

## Cài đặt dự án

Trong thư mục gốc của repo:

```bash
cd cd2btcd
flutter pub get
```

## Chạy ứng dụng

```bash
flutter run
```

Chạy trên thiết bị cụ thể (ví dụ Android):

```bash
flutter devices
flutter run -d <device_id>
```

Chạy test:

```bash
flutter test
```

Phân tích code:

```bash
flutter analyze
```

## Build bản phát hành (tùy chọn)

Ví dụ Android APK:

```bash
flutter build apk
```

Chi tiết từng nền tảng: [tài liệu Flutter — deployment](https://docs.flutter.dev/deployment).

## Cấu trúc thư mục `lib/`

| Đường dẫn | Mô tả |
|-----------|--------|
| `main.dart` | Điểm vào app, khởi tạo thông báo cục bộ, `MaterialApp` |
| `screens/diary_list_screen.dart` | Màn chính: danh sách nhật ký, sắp xếp, xóa, FAB thêm |
| `screens/create_diary_screen.dart` | Màn tạo/sửa nội dung: tiêu đề, ngày, ảnh URL, nhắc nhở |
| `models/diary_entry.dart` | Model một bản ghi nhật ký + JSON |
| `services/diary_json_storage.dart` | Đọc/ghi `diaries.json` qua `path_provider` |
| `services/diary_notifications.dart` | Lên lịch thông báo cục bộ (`flutter_local_notifications`) |
| `services/diary_reminder_schedule.dart` | Tính thời điểm nhắc + ID thông báo |
| `widgets/form_row.dart` | Hàng form nhãn + ô nhập tái sử dụng |
| `widgets/diary_thumbnail.dart` | Ảnh thumbnail từ URL trên danh sách |

Thư mục nền tảng: `android/`, `web/`, … (cấu hình build theo từng môi trường).

## Ghi chú nhanh

- **Dữ liệu:** file JSON trong thư mục documents của app — gỡ cài đặt app có thể xóa dữ liệu.
- **Thông báo:** cần cấp quyền thông báo trên hệ điều hành; chế độ «chuông» trên Android có thể cần quyền báo thức/lịch chính xác tùy máy.
- **Ảnh:** URL `http`/`https` hiển thị trong app; Android cần quyền Internet (đã khai báo trong manifest).

## Giấy phép & tài liệu Flutter

Dự án dùng Flutter — xem [tài liệu Flutter](https://docs.flutter.dev/) nếu bạn mới làm quen.

# btgkb2 — Bài học Tiếng Anh trực tuyến

Ứng dụng Flutter hiển thị **danh sách bài học trực tuyến** môn Tiếng Anh và **xem nội dung chi tiết** từng bài. Giao diện tối giản, phong cách công nghệ (nền tối, accent cyan).

## Tính năng

- **Danh sách bài học**: xem toàn bộ bài học với đơn vị (Unit), trình độ (A1–B2), thời lượng ước tính và đoạn tóm tắt ngắn.
- **Chi tiết bài học**: mở từ danh sách để đọc tóm tắt và **nội dung bài học** đầy đủ (mô tả, gợi ý luyện tập).
- **Điều hướng**: từ danh sách chạm vào thẻ bài học hoặc “Xem chi tiết” để sang màn hình chi tiết; nút quay lại trên thanh AppBar.
- **Kiến trúc MVC**: dữ liệu mẫu nằm trong **model** (`Lesson`), **controller** chỉ đọc/lọc dữ liệu, **view** là các màn hình Flutter.

## Yêu cầu môi trường

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (khuyến nghị bản ổn định mới, SDK Dart tương thích với `pubspec.yaml`).
- Để chạy trên **Android**: Android Studio / SDK, thiết bị thật hoặc emulator.
- Để chạy trên **Windows / Web / iOS**: bật thêm platform tương ứng trong `flutter doctor`.

Kiểm tra nhanh:

```bash
flutter doctor
```

## Cách chạy dự án

1. **Clone / mở thư mục dự án** (thư mục chứa `pubspec.yaml`).

2. **Lấy dependency**:

   ```bash
   flutter pub get
   ```

3. **Chọn thiết bị** (điện thoại USB, emulator, Chrome, v.v.), sau đó:

   ```bash
   flutter run
   ```

   Hoặc chạy từ IDE (VS Code / Android Studio): chọn device → Run/Debug `lib/main.dart`.

4. **Chạy test** (tùy chọn):

   ```bash
   flutter test
   ```

5. **Build APK debug** (Android):

   ```bash
   flutter build apk --debug
   ```

   File APK thường nằm tại `build/app/outputs/flutter-apk/`.

### Gợi ý khi cài app lên emulator báo hết dung lượng

Nếu lỗi kiểu `not enough space` khi cài APK: trong Android Studio → **Device Manager** → máy ảo đang dùng → **Wipe Data**, hoặc tăng **Internal Storage** trong cấu hình AVD; đảm bảo ổ đĩa máy tính còn đủ trống.

## Cấu trúc thư mục chính

| Đường dẫn | Mô tả |
|-----------|--------|
| `lib/main.dart` | Điểm vào app, theme, `LessonController`, màn hình đầu là danh sách. |
| `lib/models/lesson.dart` | Model `Lesson` và dữ liệu mẫu `Lesson.all`. |
| `lib/controllers/lesson_controller.dart` | Controller: danh sách bài, tìm theo `id`. |
| `lib/views/` | Giao diện: `lesson_list_page.dart`, `lesson_detail_page.dart`, `app_theme.dart`. |
| `test/widget_test.dart` | Test smoke cho màn danh sách. |

## Mở rộng sau này

- Thay dữ liệu tĩnh trong `Lesson` bằng API / JSON / SQLite; giữ cấu trúc `Lesson` hoặc map từ JSON vào model.
- Thêm route có tên (`onGenerateRoute` / `go_router`) nếu cần deep link tới từng bài.

## Tài liệu Flutter

- [Cài đặt Flutter](https://docs.flutter.dev/get-started/install)
- [Viết ứng dụng Flutter đầu tiên](https://docs.flutter.dev/get-started/codelab)

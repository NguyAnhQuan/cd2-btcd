import 'package:flutter_test/flutter_test.dart';

import 'package:btgkb2/main.dart';

void main() {
  testWidgets('Hiển thị trang danh sách bài học', (WidgetTester tester) async {
    await tester.pumpWidget(const EnglishLessonsApp());

    expect(find.text('Bài học trực tuyến'), findsOneWidget);
    expect(find.text('Greetings & Introductions'), findsOneWidget);
  });
}

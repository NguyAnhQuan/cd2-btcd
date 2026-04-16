import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cd2btcd/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App khởi động: tiêu đề và nút thêm', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Nhật ký'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}

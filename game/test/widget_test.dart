import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:game/controllers/settings_controller.dart';
import 'package:game/views/settings_page.dart';

void main() {
  testWidgets('Màn cấu hình hiển thị', (WidgetTester tester) async {
    final controller = SettingsController.testing();
    await tester.pumpWidget(
      MaterialApp(
        home: SettingsPage(controller: controller),
      ),
    );
    await controller.initialize();
    await tester.pump();

    expect(find.text('Cấu hình game đố vui'), findsWidgets);
    expect(find.text('Âm thanh'), findsOneWidget);
    expect(find.text('Điểm cao nhất'), findsOneWidget);
  });
}

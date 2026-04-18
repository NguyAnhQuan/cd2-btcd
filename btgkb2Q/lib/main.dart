import 'package:flutter/material.dart';

import 'controllers/lesson_controller.dart';
import 'views/app_theme.dart';
import 'views/lesson_list_page.dart';

void main() {
  runApp(const EnglishLessonsApp());
}

class EnglishLessonsApp extends StatelessWidget {
  const EnglishLessonsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LessonController();

    return MaterialApp(
      title: 'Bài học Tiếng Anh',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: LessonListPage(controller: controller),
    );
  }
}

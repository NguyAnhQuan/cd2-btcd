import 'package:flutter/material.dart';

import '../controllers/lesson_controller.dart';
import '../models/lesson.dart';

/// View: nội dung chi tiết một bài học.
class LessonDetailPage extends StatelessWidget {
  const LessonDetailPage({
    super.key,
    required this.controller,
    required this.lessonId,
  });

  final LessonController controller;
  final String lessonId;

  @override
  Widget build(BuildContext context) {
    final Lesson? lesson = controller.lessonById(lessonId);
    final accent = Theme.of(context).colorScheme.primary;

    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Không tìm thấy')),
        body: const Center(
          child: Text(
            'Bài học không tồn tại.',
            style: TextStyle(color: Color(0xFF94A3B8)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(lesson.unitLabel),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    lesson.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: Color(0xFFF1F5F9),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Chip(icon: Icons.signal_cellular_alt, label: lesson.level),
                _Chip(
                  icon: Icons.timer_outlined,
                  label: '${lesson.durationMinutes} phút',
                ),
                _Chip(
                  icon: Icons.menu_book_outlined,
                  label: 'Trực tuyến',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Tóm tắt',
              style: TextStyle(
                fontSize: 13,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
                color: accent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              lesson.summary,
              style: const TextStyle(
                fontSize: 15,
                height: 1.55,
                color: Color(0xFFCBD5E1),
              ),
            ),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1F2937)),
                color: const Color(0xFF111827),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.article_outlined, size: 20, color: accent),
                      const SizedBox(width: 8),
                      Text(
                        'Nội dung bài học',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    lesson.content,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.65,
                      color: Color(0xFFE2E8F0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF1E293B),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF22D3EE)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFFCBD5E1),
            ),
          ),
        ],
      ),
    );
  }
}

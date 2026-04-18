import 'package:flutter/material.dart';

import '../controllers/lesson_controller.dart';
import '../models/lesson.dart';
import 'lesson_detail_page.dart';

/// View: danh sách bài học trực tuyến.
class LessonListPage extends StatelessWidget {
  const LessonListPage({super.key, required this.controller});

  final LessonController controller;

  @override
  Widget build(BuildContext context) {
    final lessons = controller.lessons;
    final accent = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tiếng Anh',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                      color: accent,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Bài học trực tuyến',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF1F5F9),
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0B1220),
                      Color(0xFF0F172A),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final lesson = lessons[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _LessonCard(
                      lesson: lesson,
                      onOpen: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => LessonDetailPage(
                              controller: controller,
                              lessonId: lesson.id,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                childCount: lessons.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.lesson, required this.onOpen});

  final Lesson lesson;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1F2937)),
            color: const Color(0xFF111827),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B1220),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF1F2937)),
                      ),
                      child: Text(
                        lesson.unitLabel,
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 0.8,
                          color: accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: const Color(0xFF1E293B),
                      ),
                      child: Text(
                        lesson.level,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.schedule, size: 16, color: accent.withValues(alpha: 0.85)),
                    const SizedBox(width: 4),
                    Text(
                      '${lesson.durationMinutes} phút',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  lesson.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                    color: Color(0xFFF1F5F9),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  lesson.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Xem chi tiết',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: accent,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios_rounded, size: 12, color: accent),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

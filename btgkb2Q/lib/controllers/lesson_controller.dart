import '../models/lesson.dart';

/// Controller: truy cập dữ liệu bài học từ model (không chứa dữ liệu tĩnh).
class LessonController {
  LessonController();

  List<Lesson> get lessons => List.unmodifiable(Lesson.all);

  Lesson? lessonById(String id) => Lesson.findById(id);
}

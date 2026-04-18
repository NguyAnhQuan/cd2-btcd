/// Model: thực thể bài học và dữ liệu mẫu (toàn bộ dữ liệu hiển thị nằm tại đây).
class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.level,
    required this.durationMinutes,
    required this.summary,
    required this.content,
    required this.unitLabel,
  });

  final String id;
  final String title;
  /// Ví dụ: A1, B2 — hiển thị badge
  final String level;
  final int durationMinutes;
  final String summary;
  final String content;
  final String unitLabel;

  /// Danh sách bài học trực tuyến môn Tiếng Anh (mock — có thể thay bằng API sau).
  static const List<Lesson> all = [
    Lesson(
      id: 'eng-01',
      unitLabel: 'Unit 01',
      title: 'Greetings & Introductions',
      level: 'A1',
      durationMinutes: 25,
      summary:
          'Cách chào hỏi, giới thiệu bản thân và hỏi tên trong ngữ cảnh hàng ngày.',
      content:
          'Trong bài này bạn sẽ học các cụm chào buổi sáng/chiều/tối, cách nói "Nice to meet you", '
          'và mẫu câu "What\'s your name? / My name is...". '
          'Luyện phát âm ngắn gọn và nhấn trọng âm đúng với từ greeting.\n\n'
          'Bài tập gợi ý: ghép đoạn hội thoại, ghi âm 3 lần và so sánh với audio mẫu.',
    ),
    Lesson(
      id: 'eng-02',
      unitLabel: 'Unit 02',
      title: 'Present Simple — Habits',
      level: 'A2',
      durationMinutes: 35,
      summary:
          'Thì hiện tại đơn: diễn tả thói quen, lịch trình và sự thật hiển nhiên.',
      content:
          'Cấu trúc khẳng định / phủ định / câu hỏi với động từ thường và "to be". '
          'Từ vựng về thói quen hàng ngày (wake up, commute, exercise).\n\n'
          'Mẹo: dùng trạng từ tần suất (always, usually, sometimes) đặt trước động từ chính.',
    ),
    Lesson(
      id: 'eng-03',
      unitLabel: 'Unit 03',
      title: 'Past Simple — Stories',
      level: 'A2',
      durationMinutes: 40,
      summary:
          'Quá khứ đơn: kể sự kiện đã xảy ra, dấu hiệu nhận biết và động từ bất quy tắc.',
      content:
          'Nhận diện cụm thời gian trong quá khứ (yesterday, last week, in 2020). '
          'Danh sách động từ bất quy tắc thường gặp (go/went, see/saw).\n\n'
          'Viết đoạn 5–7 câu kể về một ngày cuối tuần của bạn.',
    ),
    Lesson(
      id: 'eng-04',
      unitLabel: 'Unit 04',
      title: 'Modal Verbs — Advice & Obligation',
      level: 'B1',
      durationMinutes: 32,
      summary:
          'must, should, have to, might: gợi ý, bắt buộc và khả năng trong giao tiếp.',
      content:
          'Phân biệt nghĩa bắt buộc pháp lý và bắt buộc cá nhân. '
          'Cấu trúc phủ định và câu hỏi với modal.\n\n'
          'Thực hành: đưa lời khuyên cho đồng nghiệp về an toàn thông tin.',
    ),
    Lesson(
      id: 'eng-05',
      unitLabel: 'Unit 05',
      title: 'Conditionals — Zero & First',
      level: 'B1',
      durationMinutes: 38,
      summary:
          'Câu điều kiện loại 0 và 1: quy luật chung và tình huống có thể xảy ra.',
      content:
          'If + present simple, present simple (truth / habit). '
          'If + present simple, will + base verb (kế hoạch, dự đoán hợp lý).\n\n'
          'Viết 4 câu điều kiện về học tập và công việc của bạn.',
    ),
    Lesson(
      id: 'eng-06',
      unitLabel: 'Unit 06',
      title: 'Passive Voice — Tech & Science',
      level: 'B2',
      durationMinutes: 45,
      summary:
          'Câu bị động trong văn bản kỹ thu học: nhấn hành động hơn tác nhân.',
      content:
          'Cấu trúc be + past participle, cách thêm "by agent" khi cần. '
          'Áp dụng cho mô tả quy trình (is deployed, was tested, has been released).\n\n'
          'Đọc đoạn ngắn và chuyển 5 câu chủ động sang bị động.',
    ),
  ];

  static Lesson? findById(String id) {
    try {
      return all.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }
}

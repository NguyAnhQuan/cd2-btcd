/// Khoảng thời gian nhắc lại tính từ ngày sự kiện trong nhật ký.
enum ReminderInterval {
  oneMinute('1 phút sau'),
  threeMonths('3 tháng sau'),
  oneYear('1 năm sau'),
  tenYears('10 năm');

  const ReminderInterval(this.label);
  final String label;
}

/// Cách gửi nhắc nhở.
enum ReminderMethod {
  ringtone('Nhắc bằng chuông'),
  email('Nhắc bằng email'),
  notification('Nhắc bằng thông báo');

  const ReminderMethod(this.label);
  final String label;
}

class DiaryEntry {
  const DiaryEntry({
    required this.title,
    required this.eventDate,
    this.imagePath,
    this.remindLater = false,
    this.reminderInterval,
    this.reminderMethod,
    /// Thời điểm bắn thông báo cho chế độ «1 phút» (lúc lưu + 1 phút), tránh nhầm với 00:01 ngày sự kiện.
    this.reminderScheduledAt,
  });

  final String title;
  final DateTime eventDate;
  final String? imagePath;
  final bool remindLater;
  final ReminderInterval? reminderInterval;
  final ReminderMethod? reminderMethod;
  final DateTime? reminderScheduledAt;

  Map<String, dynamic> toJson() => {
        'title': title,
        'eventDate': eventDate.toIso8601String(),
        'imagePath': imagePath,
        'remindLater': remindLater,
        'reminderInterval': reminderInterval?.name,
        'reminderMethod': reminderMethod?.name,
        'reminderScheduledAt': reminderScheduledAt?.toIso8601String(),
      };

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      title: json['title'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      imagePath: json['imagePath'] as String?,
      remindLater: json['remindLater'] as bool? ?? false,
      reminderInterval: _enumByName(
        ReminderInterval.values,
        json['reminderInterval'] as String?,
      ),
      reminderMethod: _enumByName(
        ReminderMethod.values,
        json['reminderMethod'] as String?,
      ),
      reminderScheduledAt: json['reminderScheduledAt'] != null
          ? DateTime.parse(json['reminderScheduledAt'] as String)
          : null,
    );
  }

  static T? _enumByName<T extends Enum>(List<T> values, String? name) {
    if (name == null) return null;
    for (final e in values) {
      if (e.name == name) return e;
    }
    return null;
  }
}

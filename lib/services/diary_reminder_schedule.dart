import '../models/diary_entry.dart';

/// ID ổn định cho [FlutterLocalNotificationsPlugin.zonedSchedule] / cancel.
int diaryNotificationId(DiaryEntry e) =>
    Object.hash(e.title, e.eventDate.toIso8601String()) & 0x7fffffff;

/// Thời điểm nhắc = ngày sự kiện (00:00 local) + khoảng [ReminderInterval].
///
/// Với «1 phút»: dùng [DiaryEntry.reminderScheduledAt] (lưu lúc bấm Ghi — lúc đó + 1 phút).
/// Trước đây tính 00:01 ngày sự kiện nên ban ngày luôn «đã quá hạn» và không lên lịch.
DateTime? diaryReminderDateTime(DiaryEntry e) {
  if (!e.remindLater || e.reminderInterval == null) return null;
  final d = DateTime(e.eventDate.year, e.eventDate.month, e.eventDate.day);
  switch (e.reminderInterval!) {
    case ReminderInterval.oneMinute:
      if (e.reminderScheduledAt != null) return e.reminderScheduledAt;
      final legacy = d.add(const Duration(minutes: 1));
      final now = DateTime.now();
      return legacy.isAfter(now)
          ? legacy
          : now.add(const Duration(minutes: 1));
    case ReminderInterval.threeMonths:
      return DateTime(d.year, d.month + 3, d.day);
    case ReminderInterval.oneYear:
      return DateTime(d.year + 1, d.month, d.day);
    case ReminderInterval.tenYears:
      return DateTime(d.year + 10, d.month, d.day);
  }
}

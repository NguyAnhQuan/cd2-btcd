import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/diary_entry.dart';
import 'diary_reminder_schedule.dart';

/// Thông báo nhắc nhật ký (chuông / thông báo / email nhắc cục bộ).
///
/// **Khác nhau giữa "chuông" và "thông báo" (Android):**
/// - Chuông: kênh `diary_ringtone`, `Importance.max`, `AndroidNotificationCategory.alarm`,
///   lịch `AndroidScheduleMode.alarmClock` — xem [_detailsFor] và [_androidScheduleMode].
/// - Thông báo: kênh `diary_notification`, mức mặc định, `AndroidScheduleMode.exactAllowWhileIdle`.
///
/// **Email:** không gửi email thật (cần SMTP/server). Chỉ lên lịch thông báo cục bộ với nội dung gợi ý mở email — xem [_bodyFor].
InitializationSettings _notificationInitSettings() {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      );
    case TargetPlatform.iOS:
      return const InitializationSettings(
        iOS: DarwinInitializationSettings(),
      );
    case TargetPlatform.windows:
      return InitializationSettings(
        windows: WindowsInitializationSettings(
          appName: 'Nhật ký',
          appUserModelId: 'com.example.cd2btcd',
          guid: 'c8f2b1a0-1234-5678-9abc-def012345678',
        ),
      );
    case TargetPlatform.linux:
      return const InitializationSettings(
        linux: LinuxInitializationSettings(defaultActionName: 'Mở'),
      );
    case TargetPlatform.macOS:
      return const InitializationSettings(
        macOS: DarwinInitializationSettings(),
      );
    default:
      return const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      );
  }
}

final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

bool _timeZoneReady = false;

Future<void> diaryNotificationsInit() async {
  if (_timeZoneReady) return;

  initializeTimeZones();

  if (!kIsWeb && !Platform.isLinux) {
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
    }
  } else {
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
    } catch (_) {}
  }
  _timeZoneReady = true;

  await _plugin.initialize(settings: _notificationInitSettings());

  if (!kIsWeb && Platform.isAndroid) {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  if (!kIsWeb && Platform.isIOS) {
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }
}

/// Đồng bộ toàn bộ lịch nhắc với danh sách đang lưu (sau tải / lưu JSON / xóa).
Future<void> diaryNotificationsSyncWithEntries(List<DiaryEntry> entries) async {
  if (kIsWeb || (!kIsWeb && Platform.isLinux)) return;

  try {
    await _plugin.cancelAll();
  } catch (_) {
    return;
  }

  final now = DateTime.now();
  for (final e in entries) {
    await _scheduleOne(e, now);
  }
}

Future<void> _scheduleOne(DiaryEntry e, DateTime now) async {
  if (!e.remindLater || e.reminderInterval == null || e.reminderMethod == null) {
    return;
  }
  final when = diaryReminderDateTime(e);
  if (when == null || !when.isAfter(now)) return;

  tz.TZDateTime scheduled;
  try {
    scheduled = tz.TZDateTime.from(when, tz.local);
  } catch (_) {
    return;
  }

  final id = diaryNotificationId(e);
  final details = _detailsFor(e.reminderMethod!);
  final mode = _androidScheduleMode(e.reminderMethod!);

  try {
    await _plugin.zonedSchedule(
      id: id,
      scheduledDate: scheduled,
      notificationDetails: details,
      androidScheduleMode: mode,
      title: _titleFor(e),
      body: _bodyFor(e),
    );
  } catch (_) {
    // Thiết bị từ chối exact alarm / quyền — bỏ qua im lặng
  }
}

String _titleFor(DiaryEntry e) => 'Nhật ký: ${e.title}';

String _bodyFor(DiaryEntry e) {
  switch (e.reminderMethod!) {
    case ReminderMethod.ringtone:
      return 'Nhắc bằng chuông — đến hạn theo ngày sự kiện.';
    case ReminderMethod.notification:
      return 'Nhắc bằng thông báo — đến hạn theo ngày sự kiện.';
    case ReminderMethod.email:
      return 'Nhắc email (cục bộ): app không gửi email tự động — mở app mail để soạn thủ công.';
  }
}

NotificationDetails _detailsFor(ReminderMethod method) {
  switch (method) {
    case ReminderMethod.ringtone:
      return const NotificationDetails(
        android: AndroidNotificationDetails(
          'diary_ringtone',
          'Nhắc bằng chuông',
          channelDescription: 'Ưu tiên cao, kiểu báo động / chuông',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          category: AndroidNotificationCategory.alarm,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
    case ReminderMethod.notification:
      return const NotificationDetails(
        android: AndroidNotificationDetails(
          'diary_notification',
          'Nhắc bằng thông báo',
          channelDescription: 'Thông báo hệ thống thông thường',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
    case ReminderMethod.email:
      return const NotificationDetails(
        android: AndroidNotificationDetails(
          'diary_email_reminder',
          'Nhắc qua email (cục bộ)',
          channelDescription: 'Nhắc nội dung — không gửi SMTP từ app',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
  }
}

AndroidScheduleMode _androidScheduleMode(ReminderMethod method) {
  switch (method) {
    case ReminderMethod.ringtone:
      return AndroidScheduleMode.alarmClock;
    case ReminderMethod.notification:
    case ReminderMethod.email:
      return AndroidScheduleMode.exactAllowWhileIdle;
  }
}

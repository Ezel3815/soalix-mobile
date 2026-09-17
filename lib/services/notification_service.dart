import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:upgrade/main.dart';

/// Daily study reminders, Duolingo-style. Two reminders, both driven by
/// a single "did the user already study today" flag stored locally:
///
///  - Study-time reminder: fires once per day at a set time.
///  - Streak-protection reminder: fires later the same day, only meant
///    to matter if the user still hasn't studied.
///
/// Rather than relying on flutter_local_notifications' built-in daily
/// repeat (which has no way to skip a single day), each reminder is
/// scheduled as a one-off for its next real occurrence — today if that
/// time hasn't passed and the user hasn't studied yet, otherwise
/// tomorrow. Scheduling reuses the same notification id, so calling it
/// again simply replaces whatever was pending. [markStudiedToday] is
/// called from the study-session completion flow and immediately rolls
/// both reminders to tomorrow.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const int _studyReminderId = 1001;
  static const int _streakReminderId = 1002;

  static const _keyStudyEnabled = "notif_study_reminder_enabled";
  static const _keyStreakEnabled = "notif_streak_reminder_enabled";
  static const _keyStudyHour = "notif_study_hour";
  static const _keyStudyMinute = "notif_study_minute";
  static const _keyStreakHour = "notif_streak_hour";
  static const _keyStreakMinute = "notif_streak_minute";
  static const _keyLastStudyDate = "notif_last_study_date";

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  bool get studyReminderEnabled => sharedPref.getBool(_keyStudyEnabled) ?? true;
  bool get streakReminderEnabled =>
      sharedPref.getBool(_keyStreakEnabled) ?? true;
  int get studyHour => sharedPref.getInt(_keyStudyHour) ?? 19;
  int get studyMinute => sharedPref.getInt(_keyStudyMinute) ?? 0;
  int get streakHour => sharedPref.getInt(_keyStreakHour) ?? 21;
  int get streakMinute => sharedPref.getInt(_keyStreakMinute) ?? 0;

  Future<void> setStudyReminderEnabled(bool value) async {
    await sharedPref.setBool(_keyStudyEnabled, value);
    if (value) {
      await _scheduleStudyReminder();
    } else {
      await _plugin.cancel(_studyReminderId);
    }
  }

  Future<void> setStreakReminderEnabled(bool value) async {
    await sharedPref.setBool(_keyStreakEnabled, value);
    if (value) {
      await _scheduleStreakReminder();
    } else {
      await _plugin.cancel(_streakReminderId);
    }
  }

  Future<void> setStudyTime(int hour, int minute) async {
    await sharedPref.setInt(_keyStudyHour, hour);
    await sharedPref.setInt(_keyStudyMinute, minute);
    if (studyReminderEnabled) await _scheduleStudyReminder();
  }

  Future<void> setStreakTime(int hour, int minute) async {
    await sharedPref.setInt(_keyStreakHour, hour);
    await sharedPref.setInt(_keyStreakMinute, minute);
    if (streakReminderEnabled) await _scheduleStreakReminder();
  }

  String get _today {
    final now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}";
  }

  bool get _studiedToday => sharedPref.getString(_keyLastStudyDate) == _today;

  /// Call once, early in app startup, before scheduling anything.
  Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    try {
      final localZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localZone));
    } catch (_) {
      // Falls back to whatever default the timezone package ships with.
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    _initialized = true;
  }

  /// Requests the OS notification permission (Android 13+ / iOS). Safe
  /// to call repeatedly — the OS only prompts once.
  Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Call every time the app comes to the foreground / the user lands
  /// on the home screen — schedules (or re-confirms) both reminders for
  /// their next real occurrence.
  Future<void> scheduleNextReminders() async {
    if (!_initialized) return;
    if (studyReminderEnabled) await _scheduleStudyReminder();
    if (streakReminderEnabled) await _scheduleStreakReminder();
  }

  /// Call right when a study session finishes. Cancels today's
  /// reminders (there's no point being told to study something you
  /// just studied) and rolls both straight to tomorrow.
  Future<void> markStudiedToday() async {
    await sharedPref.setString(_keyLastStudyDate, _today);
    if (studyReminderEnabled) await _scheduleStudyReminder();
    if (streakReminderEnabled) await _scheduleStreakReminder();
  }

  tz.TZDateTime _nextOccurrence(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    final tooLateToday = scheduled.isBefore(now) || _studiedToday;
    if (tooLateToday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  Future<void> _scheduleStudyReminder() async {
    await _plugin.zonedSchedule(
      _studyReminderId,
      "⏰ وقت مراجعتك",
      "جاهز لجلسة اليوم؟ دقائق قليلة تكفي.",
      _nextOccurrence(studyHour, studyMinute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'study_reminders',
          'Daily study reminders',
          channelDescription: 'Reminds you at your usual study time',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> _scheduleStreakReminder() async {
    await _plugin.zonedSchedule(
      _streakReminderId,
      "🔥 سلسلتك في خطر",
      "لم تراجع اليوم بعد — أكمل جلسة قصيرة قبل أن تفقد سلسلتك.",
      _nextOccurrence(streakHour, streakMinute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'streak_reminders',
          'Streak protection reminders',
          channelDescription: 'Warns you before your streak breaks',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Fires immediately — for verifying permissions/channel setup work
  /// at all, without waiting for a scheduled time to arrive.
  Future<void> showTestNotification() async {
    await _plugin.show(
      9999,
      "✅ Test notification",
      "If you can see this, notifications are working.",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'study_reminders',
          'Daily study reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  /// For debugging: what's actually scheduled right now, and when.
  Future<List<PendingNotificationRequest>> pendingNotifications() =>
      _plugin.pendingNotificationRequests();
}

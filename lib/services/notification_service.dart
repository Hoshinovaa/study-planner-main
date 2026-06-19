import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  /// INIT
  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await notifications.initialize(settings);

    await notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// NOTIFIKASI DEADLINE (2 JAM SEBELUM)
  static Future<void> scheduleDeadlineNotification({
    required int id,
    required String taskTitle,
    required DateTime deadline,
  }) async {
    final notificationTime =
        deadline.subtract(const Duration(hours: 2));

    if (notificationTime.isBefore(DateTime.now())) {
      return;
    }

    await notifications.zonedSchedule(
      id,
      '⏰ Deadline 2 Jam Lagi!',
      'Tugas "$taskTitle" akan berakhir dalam 2 jam.',
      tz.TZDateTime.from(notificationTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'deadline_channel',
          'Deadline Reminder',
          channelDescription:
              'Notifikasi pengingat deadline tugas',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// NOTIFIKASI INSTAN (UNTUK TEST)
  static Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    await notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'study_planner_channel',
          'Study Planner Notifications',
          channelDescription:
              'Notifikasi aplikasi Study Planner',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
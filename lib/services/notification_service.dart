import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// INIT
  static Future<void> init() async {
    const android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: android,
    );

    await _plugin.initialize(settings);

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    const AndroidNotificationChannel channel =
        AndroidNotificationChannel(
      'study_planner_channel',
      'Study Planner Notifications',
      description: 'Notifikasi aplikasi Study Planner',
      importance: Importance.max,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// NOTIFIKASI INSTAN
  static Future<void> showInstantNotification({
    required String title,
    required String body,
    bool playSound = true,
  }) async {
    final androidDetails =
        AndroidNotificationDetails(
      'study_planner_channel',
      'Study Planner Notifications',
      channelDescription:
          'Notifikasi aplikasi Study Planner',
      importance: Importance.max,
      priority: Priority.high,
      playSound: playSound,
      enableVibration: playSound,
    );

    await _plugin.show(
      0,
      title,
      body,
      NotificationDetails(android: androidDetails),
    );

    await saveToFirestore(
      title: title,
      desc: body,
    );
  }

  /// SIMPAN KE FIRESTORE
  static Future<void> saveToFirestore({
    required String title,
    required String desc,
  }) async {
    final uid =
        FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('notifications')
        .add({
      'uid': uid,
      'title': title,
      'desc': desc,
      'createdAt':
          FieldValue.serverTimestamp(),
    });
  }

  /// NOTIFIKASI + FIRESTORE
  static Future<void> createNotification({
    required String title,
    required String body,
    bool playSound = true,
  }) async {
    await saveToFirestore(
      title: title,
      desc: body,
    );

    await showInstantNotification(
      title: title,
      body: body,
      playSound: playSound,
    );
  }

  /// DEADLINE H-1 JAM
  static Future<void>
      scheduleDeadlineNotification({
    required String taskId,
    required String title,
    required String matkul,
    required DateTime deadline,
    required bool playSound,
  }) async {
    final scheduledTime =
        deadline.subtract(
      const Duration(hours: 1),
    );

    if (scheduledTime.isBefore(
      DateTime.now(),
    )) {
      return;
    }

    await _plugin.zonedSchedule(
      taskId.hashCode,
      "Deadline Hampir Tiba ⏰",
      "Tugas $matkul akan deadline 1 jam lagi",
      tz.TZDateTime.from(
        scheduledTime,
        tz.local,
      ),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'deadline_channel',
          'Deadline Notification',
          channelDescription:
              'Pengingat deadline tugas',
          importance: Importance.max,
          priority: Priority.high,
          playSound: playSound,
          enableVibration: playSound,
        ),
      ),
      androidScheduleMode:
          AndroidScheduleMode
              .exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation
              .absoluteTime,
    );

    await saveToFirestore(
      title: "Deadline Dijadwalkan",
      desc:
          "Reminder untuk tugas $title berhasil dibuat",
    );
  }
}
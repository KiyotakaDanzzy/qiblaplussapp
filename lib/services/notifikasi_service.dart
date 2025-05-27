import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotifikasiService {
  static final FlutterLocalNotificationsPlugin _notif =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tzdata.initializeTimeZones();
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);
    await _notif.initialize(initSettings);
  }

  static Future<void> jadwalkanAdzan(
      int id, DateTime waktu, String namaShalat, String soundName) async {
    await _notif.zonedSchedule(
      id,
      'Waktunya $namaShalat',
      'Sudah masuk waktu $namaShalat',
      tz.TZDateTime.from(waktu, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'adzan_channel',
          'Adzan',
          channelDescription: 'Notifikasi adzan otomatis',
          sound: RawResourceAndroidNotificationSound(soundName),
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  static Future<void> batalkanAdzan(int id) async {
    await _notif.cancel(id);
  }
}

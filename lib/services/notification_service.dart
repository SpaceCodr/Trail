import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();

  NotificationService._();

  final _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    var initializationSettingsAndriod =
        const AndroidInitializationSettings('@drawable/app');
    var initializationSettingsIOS = const IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndriod, iOS: initializationSettingsIOS);
    await _notifications.initialize(initializationSettings);
  }

  Future<NotificationDetails> _notificationDetails({String? soundName}) async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'main_channel',
        'Main Channel',
        playSound: soundName != null,
        sound: RawResourceAndroidNotificationSound(soundName),
        channelDescription: 'Main channel notifications',
        importance: Importance.max,
        priority: Priority.max,
        icon: '@drawable/app',
      ),
      iOS: IOSNotificationDetails(
        sound: soundName ?? 'default.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<void> showNotication({
    required String title,
    required String payload,
    String? soundName,
  }) async =>
      await _notifications.show(
        0,
        title,
        payload,
        await _notificationDetails(soundName: soundName),
      );
}

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint(
    'notificationTapBackground | '
    'id=${notificationResponse.id}, '
    'actionId=${notificationResponse.actionId}, '
    'payload=${notificationResponse.payload}',
  );
}

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  static Future<void> onDidReceiveNotification(
    NotificationResponse notificationResponse,
  ) async {
    debugPrint(
      'onDidReceiveNotification | '
      'id=${notificationResponse.id}, '
      'actionId=${notificationResponse.actionId}, '
      'payload=${notificationResponse.payload}',
    );
  }

  static Future<void> init() async {
    if (_isInitialized) return;

    /// Timezone wajib diinisialisasi kalau mau pakai zonedSchedule
    tz_data.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
        /// Lebih disarankan pakai drawable icon monokrom, mis. ic_notification
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iOSInitializationSettings,
        );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await _requestPermissions();
    await _createAndroidChannels();

    _isInitialized = true;
  }

  static Future<void> _requestPermissions() async {
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.requestNotificationsPermission();

    final iosImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    final macImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();

    await macImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> _createAndroidChannels() async {
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation == null) return;

    await androidImplementation.createNotificationChannel(
      const AndroidNotificationChannel(
        'instant_notification_channel_id',
        'Instant Notifications',
        description: 'Channel untuk notifikasi instan',
        importance: Importance.max,
      ),
    );

    await androidImplementation.createNotificationChannel(
      const AndroidNotificationChannel(
        'reminder_channel',
        'Reminder Channel',
        description: 'Channel untuk notifikasi pengingat',
        importance: Importance.high,
      ),
    );
  }

  static Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'instant_notification_channel_id',
        'Instant Notifications',
        channelDescription: 'Channel untuk notifikasi instan',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload ?? 'instant_notification',
    );
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel',
        'Reminder Channel',
        channelDescription: 'Channel untuk notifikasi pengingat',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      payload: payload ?? 'scheduled_notification',
      matchDateTimeComponents: matchDateTimeComponents,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}

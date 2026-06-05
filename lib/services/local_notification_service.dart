import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin plugin;

  LocalNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel insightChannel =
      AndroidNotificationChannel(
        'health_analyzer_insights',
        'Health Analyzer insights',
        description:
            'Recovery, training plan, sync, and personal record notifications.',
        importance: Importance.defaultImportance,
      );

  static const AndroidNotificationDetails _androidDetails =
      AndroidNotificationDetails(
        'health_analyzer_insights',
        'Health Analyzer insights',
        channelDescription:
            'Recovery, training plan, sync, and personal record notifications.',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        category: AndroidNotificationCategory.recommendation,
      );

  static const NotificationDetails _details = NotificationDetails(
    android: _androidDetails,
  );

  Future<void> initialize({bool requestPermission = false}) async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
    );
    await plugin.initialize(settings);
    await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(insightChannel);
    if (requestPermission) {
      await plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) {
    return plugin.show(id, title, body, _details, payload: payload);
  }
}

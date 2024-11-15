import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class LocalNotifications {
  static GlobalKey<NavigatorState>? navigatorKey;

  static Future<void> requestPermissionLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    print('Local notifications permission requested');
  }

  static Future<void> initializeLocalNotifications(
    GlobalKey<NavigatorState> navKey,
  ) async {
    navigatorKey = navKey;
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    print('Local notifications initialized');

    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    //TODO ios configuration

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // TODO ios configuration settings
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  static void showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data,
  }) {
    const androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      //TODO IOS
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails,
        payload: data);
  }

  static void onDidReceiveNotificationResponse(NotificationResponse response) {
    final payload = response.payload;

    if (payload != null && navigatorKey != null) {
      navigatorKey!.currentState?.pushNamed(
        'home/notification/details',
        arguments: {
          'pushMessageId': payload,
        },
      );
    } else {
      print('No payload found');
    }
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initializeNotifications();
  }

  // Initialisation des paramètres de notification
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  // Méthode publique pour afficher une notification personnalisable
  Future<void> showNotification({
    required String title,
    required String body,
    int delayInSeconds = 0,
    Importance importance = Importance.max,
    Priority priority = Priority.high,
  }) async {
    // Si un délai est défini, on attend avant de montrer la notification
    if (delayInSeconds > 0) {
      Timer(Duration(seconds: delayInSeconds), () {
        _showNotification(title, body, importance, priority);
      });
    } else {
      _showNotification(title, body, importance, priority);
    }
  }

  // Méthode privée pour montrer la notification
  Future<void> _showNotification(String title, String body, Importance importance, Priority priority) async {
    // Demander la permission avant d'envoyer la notification
    await _requestNotificationPermission();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'basic_channel', // CanalID
      'Basic Notifications', // Nom du canal
      channelDescription: 'Channel for basic notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'test_payload',
    );
  }
}

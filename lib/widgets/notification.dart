import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:sport60/domain/planning_domain.dart';
import 'package:flutter/material.dart'; // Pour la navigation
import 'package:sport60/views/planning/planning_list.dart';
import 'package:sport60/main.dart'; // Assurez-vous que navigatorKey est exporté

class NotificationService {
  // Instance unique de NotificationService
  static final NotificationService _instance = NotificationService._internal();

  // Factory constructor pour retourner l'instance unique
  factory NotificationService() {
    return _instance;
  }

  // Constructeur interne
  NotificationService._internal() {
    _initializeNotifications();
  }

  final Set<String> _sentNotifications = {}; // Track sent notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialisation des paramètres de notification
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        _onSelectNotification(notificationResponse.payload);
      },
    );
  }

  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
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
    String? payload, // Add payload parameter
  }) async {
    // Si un délai est défini, on attend avant de montrer la notification
    if (delayInSeconds > 0) {
      Timer(Duration(seconds: delayInSeconds), () {
        _showNotification(title, body, importance, priority, payload);
      });
    } else {
      _showNotification(title, body, importance, priority, payload);
    }
  }

  // Schedule notifications for upcoming sessions
  Future<void> scheduleSessionNotifications(
      List<PlanningDomain> sessions) async {
    for (var session in sessions) {
      final sessionDateTime = DateTime.parse('${session.date} ${session.time}');
      final now = DateTime.now();

      if (sessionDateTime.isAfter(now)) {
        final difference = sessionDateTime.difference(now).inMinutes;
        final notificationId = 'session_${session.id}';

        if (!_sentNotifications.contains(notificationId)) {
          if (difference <= 5 && difference > 0) {
            // Notification pour moins de 5 minutes
            await showNotification(
              title: 'Session Starting Soon',
              body:
                  'Votre session "${session.sessionName}" commence dans moins de 5 minutes.',
              payload: notificationId, // Add payload for navigation
            );
            _sentNotifications.add(notificationId); // Marquer comme envoyé
          } else if (difference <= 60 && difference > 5) {
            // Notification pour 1 heure
            await showNotification(
              title: 'Upcoming Session',
              body:
                  'Votre session "${session.sessionName}" commence dans 1 heure.',
              payload: notificationId, // Add payload for navigation
            );
            _sentNotifications.add(notificationId); // Marquer comme envoyé
          }
        }
      }
    }
  }

  // Méthode privée pour montrer la notification
  Future<void> _showNotification(String title, String body,
      Importance importance, Priority priority, String? payload) async {
    // Vérifier si l'utilisateur est déjà sur la page planning_list
    if (_isOnPlanningListPage()) {
      return; // Ne pas afficher la notification si déjà sur planning_list
    }

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

    // Utiliser un ID unique basé sur le payload
    int notificationId = payload != null ? payload.hashCode : 0;

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Handle notification taps
  Future<void> _onSelectNotification(String? payload) async {
    if (payload != null && !_sentNotifications.contains(payload)) {
      // Marquer la notification comme traitée
      _sentNotifications.add(payload);

      // Naviguer vers la page planning_list en passant le payload
      navigatorKey.currentState?.pushNamed(
        '/planning_list',
        arguments: payload,
      );
    }
  }

  // Nouvelle méthode pour vérifier la page actuelle
  bool _isOnPlanningListPage() {
    final currentContext = navigatorKey.currentState?.overlay?.context;
    if (currentContext != null) {
      ModalRoute? route = ModalRoute.of(currentContext);
      return route?.settings.name == '/planning_list';
    }
    return false;
  }
}

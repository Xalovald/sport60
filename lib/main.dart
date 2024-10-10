import 'package:flutter/material.dart';
import 'package:sport60/views/home.dart';
import 'package:sport60/views/history/history_list.dart';
import 'package:sport60/views/planning/planning_list.dart';
import 'package:sport60/widgets/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const HistoryList(),
    const HomePage(),
    const PlanningList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sport60'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              _showNotificationWithDelay(context);  // Appeler la fonction de notification avec un délai
            }, // Utiliser le widget pour afficher une notification
          ),
          IconButton(
            icon: const Icon(Icons.add_alert),
            onPressed: () {
              _showNotification(context);  // Appeler la fonction de notification avec un délai
            }, // Utiliser le widget pour afficher une notification
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Historique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Séances',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Afficher un SnackBar et déclencher la notification après un délai
  void _showNotificationWithDelay(BuildContext context) {
    // Afficher un SnackBar pour informer l'utilisateur
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Une notification apparaîtra dans 5 secondes.'),
      ),
    );

    // Appeler le service de notification après 5 secondes
    NotificationService().showNotification(
      title: 'POC Notification avec time',
      body: 'Ceci est personnalisée.',
      delayInSeconds: 3,
    );
  }
  // Déclencher la notification direct
  void _showNotification(BuildContext context) {
    // Appeler le service de notification après 5 secondes
    NotificationService().showNotification(
      title: 'POC Notification',
      body: 'Ceci est une notification personnalisée sans time.',
      delayInSeconds: 0,
    );
  }

  /*// Function show notif (POC)
  Future<void> _showNotification() async {
    // Ask permission before send notif
    await _requestNotificationPermission();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'basic_channel', // CanalID
      'Basic Notifications', // Canal name
      channelDescription: 'Channel for basic notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'POC Notification',
      'Ceci est une notification de test',
      platformChannelSpecifics,
      payload: 'test_payload',
    );
  }*/
}

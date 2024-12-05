import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport60/views/history/history_list.dart';
import 'package:sport60/views/home.dart';
import 'package:sport60/views/planning/planning_list.dart';
import 'package:sport60/widgets/notification.dart';
import 'package:sport60/widgets/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sport60'),
        backgroundColor: themeNotifier.currentTheme.primaryColor,
        foregroundColor: themeNotifier.currentTheme.textTheme.headlineSmall?.color,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: themeNotifier.currentTheme.primaryColor,
              ),
              child: Text(
                'Actions',
                style: TextStyle(
                  color: themeNotifier.currentTheme.textTheme.headlineSmall?.color,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Show Notification with Delay'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _showNotificationWithDelay(context); // Call the notification function with a delay
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_alert),
              title: const Text('Show Notification'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _showNotification(context); // Call the notification function
              },
            ),
            ListTile(
              leading: const Icon(Icons.sunny),
              title: const Text('Light Theme'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Provider.of<ThemeNotifier>(context, listen: false).setLightTheme();
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark Theme'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Provider.of<ThemeNotifier>(context, listen: false).setDarkTheme();
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Disconnect'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _disconnect(); // Call the disconnect function
              },
            ),
          ],
        ),
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
        selectedItemColor: themeNotifier.currentTheme.colorScheme.secondary,
        onTap: _onItemTapped,
      ),
    );
  }

  void _showNotificationWithDelay(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Une notification apparaîtra dans 5 secondes.'),
      ),
    );

    NotificationService().showNotification(
      title: 'POC Notification avec time',
      body: 'Ceci est personnalisée.',
      delayInSeconds: 3,
    );
  }

  void _showNotification(BuildContext context) {
    NotificationService().showNotification(
      title: 'POC Notification',
      body: 'Ceci est une notification personnalisée sans time.',
      delayInSeconds: 0,
    );
  }

  void _disconnect() async {
    await FirebaseAuth.instance.signOut();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}

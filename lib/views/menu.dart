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
        backgroundColor: themeNotifier.currentTheme.primaryColor,
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
          leading: Icon(Icons.notifications, color: themeNotifier.currentTheme.iconTheme.color),
          title: Text('Show Notification with Delay', style: TextStyle(color: themeNotifier.currentTheme.textTheme.bodyMedium?.color)),
          onTap: () {
            Navigator.pop(context); // Close the drawer
            _showNotificationWithDelay(context); // Call the notification function with a delay
          },
        ),
        ListTile(
          leading: Icon(Icons.add_alert, color: themeNotifier.currentTheme.iconTheme.color),
          title: Text('Show Notification', style: TextStyle(color: themeNotifier.currentTheme.textTheme.bodyMedium?.color)),
          onTap: () {
            Navigator.pop(context); // Close the drawer
            _showNotification(context); // Call the notification function
          },
        ),
        ListTile(
          leading: Icon(Icons.sunny, color: themeNotifier.currentTheme.iconTheme.color),
          title: Text('Light Theme', style: TextStyle(color: themeNotifier.currentTheme.textTheme.bodyMedium?.color)),
          onTap: () {
            Navigator.pop(context); // Close the drawer
            Provider.of<ThemeNotifier>(context, listen: false).setLightTheme();
          },
        ),
        ListTile(
          leading: Icon(Icons.dark_mode, color: themeNotifier.currentTheme.iconTheme.color),
          title: Text('Dark Theme', style: TextStyle(color: themeNotifier.currentTheme.textTheme.bodyMedium?.color)),
          onTap: () {
            Navigator.pop(context); // Close the drawer
            Provider.of<ThemeNotifier>(context, listen: false).setDarkTheme();
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app, color: themeNotifier.currentTheme.iconTheme.color),
          title: Text('Disconnect', style: TextStyle(color: themeNotifier.currentTheme.textTheme.bodyMedium?.color)),
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

import 'package:flutter/material.dart';
import 'package:sport60/views/home.dart';
import 'package:sport60/views/history/history_list.dart';
import 'package:sport60/views/planned/planned_list.dart';
import 'package:sport60/widgets/notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sport60/views/auth/auth_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<FirebaseApp> _initializeFirebase() async {
    return await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Flutter Firebase Auth',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: _getHomePage(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error initializing Firebase'),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _getHomePage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const AuthPage();
        }
      },
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
    const PlannedList(),
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
        /* actions: [
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
        ], */
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Actions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Show Notification with Delay'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _showNotificationWithDelay(
                    context); // Call the notification function with a delay
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

  void _disconnect() {
    // Add your disconnect logic here
    // For example, sign out from Firebase Auth
    FirebaseAuth.instance.signOut();
    // Navigate to the login screen or show a message
    Navigator.pushReplacementNamed(context, '/login');
  }
}

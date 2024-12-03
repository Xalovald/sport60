import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport60/firebase_options.dart';
import 'package:sport60/views/home.dart';
import 'package:sport60/views/history/history_list.dart';
import 'package:sport60/views/planning/planning_list.dart';
import 'package:sport60/widgets/notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sport60/views/auth/auth_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sport60/widgets/theme.dart'; // Import ThemeNotifier
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Import BlockPicker

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Sport60',
          theme: themeNotifier.currentTheme,
          home: _getHomePage(),
          routes: {
            '/login': (context) => const AuthPage(),
          },
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
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: ThemeNotifier.lightModeButtonColor,
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
              leading: const Icon(Icons.palette),
              title: const Text('Choose Custom Theme Color'),
              onTap: () async {
              Navigator.pop(context); // Close the drawer
              Color? selectedColor = await showDialog(
                context: context,
                builder: (context) {
                  Color pickerColor = ThemeNotifier.defaultThemeColor;
                  return AlertDialog(
                    title: const Text('Select Custom Theme Color'),
                    content: SingleChildScrollView(
                      child: BlockPicker(
                        pickerColor: pickerColor,
                        onColorChanged: (color) {
                          Navigator.of(context).pop(color);
                        },
                      ),
                    ),
                  );
                },
              );
              if (selectedColor != null) {
                Provider.of<ThemeNotifier>(context, listen: false).setCustomTheme(selectedColor);
              }
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

  void _disconnect() async {
    await FirebaseAuth.instance.signOut();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    //cancel timer

    // Navigate to the login screen or show a message
    Navigator.pushReplacementNamed(context, '/login');
  }
}

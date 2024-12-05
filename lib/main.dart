import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport60/firebase_options.dart';
import 'package:sport60/views/home.dart';
import 'package:sport60/views/auth/auth_page.dart';
import 'package:sport60/widgets/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sport60/views/menu.dart'; // Import HomeScreen
import 'package:sport60/views/planning/planning_list.dart'; // Import PlanningList
import 'package:sport60/widgets/notification.dart'; // Import NotificationService
import 'package:sport60/services/planning_service.dart'; // Import PlanningService
import 'package:sport60/domain/planning_domain.dart'; // Import PlanningDomain

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialiser NotificationService
  NotificationService notificationService = NotificationService();
  List<PlanningDomain> sessions = await PlanningService().getPlannings();
  await notificationService.scheduleSessionNotifications(sessions);
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
          navigatorKey: navigatorKey, // Ajouter la clé globale
          initialRoute: '/',
          home: _getHomePage(),
          routes: {
            '/login': (context) => const AuthPage(),
            '/planning_list': (context) => const PlanningList(),
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

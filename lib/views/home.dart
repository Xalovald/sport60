import 'package:flutter/material.dart';
import 'package:sport60/widgets/button.dart';
import 'package:sport60/views/planning/choose_session.dart';
import 'package:sport60/widgets/theme.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        backgroundColor: themeNotifier.currentTheme.primaryColor,
        foregroundColor:
            themeNotifier.currentTheme.textTheme.headlineSmall?.color,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: themeNotifier.currentTheme.colorScheme.primary,
              child: Icon(
                Icons.fitness_center,
                size: 50,
                color: themeNotifier.currentTheme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Bienvenue chez Sport60!",
              style: themeNotifier.currentTheme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Nous vous accompagnons pour atteindre vos objectifs de forme et de bien-être grâce à des séances adaptées et personnalisées",
              style: themeNotifier.currentTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 120),
            Text(
              "Pour commencer, planifier votre séance",
              style: themeNotifier.currentTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomButton(
              onClick: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ChooseSession(),
                ))
              },
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [themeNotifier.customButtonColor, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                    color: themeNotifier.currentTheme.colorScheme.secondary,
                    width: 2
                    ),
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              heroTag: 'ChooseSessionButton',
              child: Text(
                "Planifier une séance",
                style: TextStyle(
                  color: themeNotifier.currentTheme.textTheme.headlineSmall?.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

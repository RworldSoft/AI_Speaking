import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/theme.dart';
import 'services/connectivity_service.dart';
import 'screens/onboarding_screen.dart';
import 'screens/privacy_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final privacyAccepted = prefs.getBool('privacy_accepted') ?? false;

  // Wrapping the entire app in ProviderScope to enable Riverpod state management.
  runApp(
    ProviderScope(
      child: MyApp(privacyAccepted: privacyAccepted),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool privacyAccepted;

  const MyApp({super.key, required this.privacyAccepted});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        // Initialize connectivity service with context
        connectivityService.init(context);
        return child!;
      },
      title: 'BetterSpeak',
      debugShowCheckedModeBanner: false,
      // Applying the custom global theme defined in utils/theme.dart
      theme: AppTheme.lightTheme,
      home: privacyAccepted ? const OnboardingScreen() : const PrivacyScreen(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to BetterSpeak',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}

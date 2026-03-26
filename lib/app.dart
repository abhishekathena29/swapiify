import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swapiify/screens/onboarding_screen.dart';

import 'providers/auth_provider.dart';
import 'routes/app_router.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

class SwapiifyApp extends StatelessWidget {
  const SwapiifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swapiify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      onGenerateRoute: AppRouter.generateRoute,
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.user == null) {
      return const OnboardingScreen();
    }
    if (auth.profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return const HomeScreen();
  }
}

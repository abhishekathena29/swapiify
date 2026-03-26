import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swapiify/app.dart';
import 'package:swapiify/firebase_options.dart';
import 'package:swapiify/providers/auth_provider.dart';
import 'package:swapiify/providers/chat_provider.dart';
import 'package:swapiify/providers/favorites_provider.dart';
import 'package:swapiify/providers/items_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ItemsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const SwapiifyApp(),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'state/auth_provider.dart';      // globaler Login-Status
import 'app_start/auth_gate.dart';      // zeigt LoginPage oder MainNavigation

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');          // Secrets & Keys laden

  runApp(
    ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider()..restore(), // vorhandene Session prüfen
      child: const TuneTalkrApp(),
    ),
  );
}

/// Root-Widget der App.  Hält nur Theme & leitet an den AuthGate weiter.
class TuneTalkrApp extends StatelessWidget {
  const TuneTalkrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TuneTalkr',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Colors.white,
        ),
        iconTheme: const IconThemeData(size: 28, color: Colors.white),
        primaryColor: const Color(0xFF1DB954),
        fontFamily: 'Roboto',
        textTheme:
            const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: const AuthGate(),            // entscheidet: LoginPage oder Home
    );
  }
}

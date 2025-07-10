import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'state/auth_provider.dart';      // global Auth-Provider for Login-state
import 'app_start/auth_gate.dart';      // shows LoginPage or MainNavigation

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');          // load Secrets & Keys 

  runApp(
    ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider()..restore(), 
      child: const TuneTalkrApp(),
    ),
  );
}

/// Root widget of the app. Holds only the theme and delegates to the AuthGate.
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
      home: const AuthGate(),            
    );
  }
}

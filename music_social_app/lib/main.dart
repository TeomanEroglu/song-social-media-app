import 'package:flutter/material.dart';
import 'navigation/main_navigation.dart';

void main() {
  runApp(MyMusicApp());
}

class MyMusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Social App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF121212),
        iconTheme: IconThemeData(size: 28, color: Colors.white),
        primaryColor: Color(0xFF1DB954),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Colors.white,
        ),
      ),
      home: MainNavigation(),
    );
  }
}

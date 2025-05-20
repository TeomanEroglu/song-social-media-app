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
        scaffoldBackgroundColor: Color(0xFFF9F9F9),
        iconTheme: IconThemeData(size: 28),
        primarySwatch:
            Colors
                .grey, //Durch Swatch können verschiedene Abstufungen von der Farbe grey verwendet werden
        fontFamily: 'Roboto',
      ),
      home: MainNavigation(),
    );
  }
}

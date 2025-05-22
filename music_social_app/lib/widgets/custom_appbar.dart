import 'package:flutter/material.dart';
import '../views/messages/messages_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF121212), // Spotify Dark
      elevation: 0.5,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white, // Primärtextfarbe
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.mail_outline,
            color: Color(0xFF1DB954), // Spotify Grün
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MessagesPage()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

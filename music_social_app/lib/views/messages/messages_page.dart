import 'package:flutter/material.dart';
import 'chat_page.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> messages = [
      {'name': 'Alice', 'lastMessage': 'Yes, I love it too!'},
      {'name': 'Jacob', 'lastMessage': 'Check out this song'},
      {'name': 'Emily', 'lastMessage': 'Sounds good!'},
      {'name': 'Michael', 'lastMessage': 'Have you heard this?'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView.separated(
        itemCount: messages.length,
        separatorBuilder:
            (context, index) => Divider(color: Colors.grey.shade800, height: 1),
        itemBuilder: (context, index) {
          final message = messages[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF1DB954),
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              message['name']!,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              message['lastMessage']!,
              style: const TextStyle(color: Color(0xFFB3B3B3)),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatPage(userName: message['name']!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

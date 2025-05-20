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
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: ListView.separated(
        itemCount: messages.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final message = messages[index];
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(message['name']!),
            subtitle: Text(message['lastMessage']!),
            trailing: const Icon(Icons.chevron_right),
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

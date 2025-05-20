import 'package:flutter/material.dart';
import '../../data/feed_data.dart';

class SongCommentsPage extends StatelessWidget {
  final Map<String, String> song;

  const SongCommentsPage({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final commentsForSong =
        feedPosts.where((post) {
          return post['song']['title'] == song['title'];
        }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(song['title'] ?? 'Song Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🎵 Coverbild
            Image.asset(
              'assets/images/cover1.jpg', // ⬅️ Optional: song['image']
              height: 220,
              width: 220,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            // 🎤 Songinfos
            Text(
              song['title'] ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Text(
              song['artist'] ?? '',
              style: const TextStyle(fontSize: 15, color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // 💬 Kommentare
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Comments',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (commentsForSong.isEmpty)
              const Text(
                'No comments yet.',
                style: TextStyle(color: Colors.grey),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: commentsForSong.length,
                itemBuilder: (context, index) {
                  final post = commentsForSong[index];
                  final comment = post['comment'];
                  final rating = post['rating'];
                  final user = post['user'] ?? 'User';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(
                            'assets/images/profile.jpg',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$user  •  ${rating.toString()} ★',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(comment),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

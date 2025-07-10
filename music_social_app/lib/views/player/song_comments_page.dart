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
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(song['title'] ?? 'Song Details'),
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Coverimage
            Image.asset(
              'assets/images/cover1.jpg',
              height: 260,
              width: 260,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            // Songtitel and Artist
            Text(
              song['title'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              song['artist'] ?? '',
              style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Player-Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.shuffle, color: Color(0xFFB3B3B3)),
                Icon(Icons.skip_previous, size: 32, color: Colors.white),
                Icon(Icons.play_circle_fill, size: 56, color: Colors.white),
                Icon(Icons.skip_next, size: 32, color: Colors.white),
                Icon(Icons.repeat, color: Color(0xFFB3B3B3)),
              ],
            ),
            const SizedBox(height: 32),

            // Comments Headline  
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Comments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Comments List
            if (commentsForSong.isEmpty)
              const Text(
                'No comments yet.',
                style: TextStyle(color: Color(0xFFB3B3B3)),
              )
            else
              ...commentsForSong.map((post) {
                final comment = post['comment'];
                final rating = post['rating'];
                final user = post['user'] ?? 'User';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF181818),
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
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              comment,
                              style: const TextStyle(color: Color(0xFFB3B3B3)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}

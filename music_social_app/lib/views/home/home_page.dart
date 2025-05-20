import 'package:flutter/material.dart';
import '../../widgets/custom_appbar.dart';
import '../../data/feed_data.dart';
import '../player/song_comments_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Home'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            feedPosts.isEmpty
                ? const Center(
                  child: Text(
                    'No posts yet.\nRate & comment songs to see them here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                : ListView.builder(
                  itemCount: feedPosts.length,
                  itemBuilder: (context, index) {
                    final post = feedPosts[index];
                    final song = post['song'];
                    final rating = post['rating'];
                    final comment = post['comment'];
                    final timestamp = post['timestamp'] as DateTime;
                    final user = post['user'] ?? 'User A';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 4.0,
                            bottom: 6,
                            top: 12,
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 12,
                                backgroundImage: AssetImage(
                                  'assets/images/profile.jpg',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$user has posted',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Animierter Übergang
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                pageBuilder:
                                    (_, animation, __) =>
                                        SongCommentsPage(song: song),
                                transitionsBuilder:
                                    (_, animation, __, child) => FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Card(
                                margin: const EdgeInsets.only(bottom: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                color: const Color(0xFFF8F4FF),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              song['title'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              song['artist'] ?? '',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: List.generate(5, (i) {
                                                return Icon(
                                                  i < rating
                                                      ? Icons.star_rounded
                                                      : Icons
                                                          .star_border_rounded,
                                                  color:
                                                      i < rating
                                                          ? Colors.amber
                                                          : Colors.grey[400],
                                                  size: 20,
                                                );
                                              }),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              '"$comment"',
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          'assets/images/cover1.jpg',
                                          width: 80,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 6,
                                right: 12,
                                child: Text(
                                  _formatTime(timestamp),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final duration = DateTime.now().difference(time);
    if (duration.inMinutes < 1) return 'just now';
    if (duration.inMinutes < 60) return '${duration.inMinutes} min ago';
    if (duration.inHours < 24) return '${duration.inHours}h ago';
    return '${duration.inDays}d ago';
  }
}

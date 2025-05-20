import 'package:flutter/material.dart';
import '../../data/feed_data.dart';
import '../player/song_comments_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  final String currentUser = 'Antonia';

  @override
  Widget build(BuildContext context) {
    final userPosts =
        feedPosts.where((post) => post['user'] == currentUser).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
            const SizedBox(height: 12),

            Text(
              currentUser,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8E6F7),
                foregroundColor: Colors.deepPurple,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Edit profile'),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Column(
                  children: [
                    Text('120', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Following', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Column(
                  children: [
                    Text('88', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Followers', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Music lover. Concert goer. Always looking for new tracks.',
                style: TextStyle(fontSize: 15),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Add Friend'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade50,
                foregroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
            ),

            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),

            if (userPosts.isEmpty)
              const Text(
                'You haven’t posted anything yet.',
                style: TextStyle(color: Colors.grey),
              )
            else
              ...userPosts.map((post) {
                final song = post['song'];
                final comment = post['comment'];
                final rating = post['rating'];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder:
                            (_, animation, __) => SongCommentsPage(song: song),
                        transitionsBuilder:
                            (_, animation, __, child) => FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                      ),
                    );
                  },
                  child: _buildActivityItem(
                    song['title'],
                    comment,
                    (rating as num).toDouble(),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String comment, double rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(comment),
              ],
            ),
          ),
          Text('${rating.toStringAsFixed(1)} ★'),
        ],
      ),
    );
  }
}

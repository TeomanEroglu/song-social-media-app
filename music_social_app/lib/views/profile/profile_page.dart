import 'package:flutter/material.dart';
import '../../data/feed_data.dart';
import '../player/song_comments_page.dart';
import '../profile/edit_bio_page.dart'; // Pfad ggf. anpassen

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentUser = 'Antonia';

  String bio = 'Music lover. Concert goer. Always looking for new tracks.';

  void _editBio() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditBioPage(currentBio: bio)),
    );

    if (result != null && result is String && result.trim().isNotEmpty) {
      setState(() {
        bio = result.trim();
      });

      // Optional: Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Bio updated'),
          backgroundColor: Color(0xFF1DB954),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userPosts =
        feedPosts.where((post) => post['user'] == currentUser).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
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
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {}, // Add Friend Action
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Add Friend'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A2A2A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _editBio,
                  icon: const Icon(Icons.edit),
                  label: const Text('Change Bio'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A2A2A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Column(
                  children: [
                    Text(
                      '120',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Following',
                      style: TextStyle(color: Color(0xFFB3B3B3)),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '88',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Followers',
                      style: TextStyle(color: Color(0xFFB3B3B3)),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF181818),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                bio,
                style: const TextStyle(fontSize: 15, color: Colors.white),
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
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),

            if (userPosts.isEmpty)
              const Text(
                'You haven’t posted anything yet.',
                style: TextStyle(color: Color(0xFFB3B3B3)),
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
        color: const Color(0xFF181818),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(comment, style: const TextStyle(color: Color(0xFFB3B3B3))),
              ],
            ),
          ),
          Text(
            '${rating.toStringAsFixed(1)} ★',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

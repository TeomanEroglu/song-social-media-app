import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/auth_provider.dart';
import '../../data/feed_data.dart';
import '../profile/edit_bio_page.dart';
import '../player/song_comments_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  //  Usse Bio
  String bio = 'Music lover. Concert goer. Always looking for new tracks.';

  //  KeepAlive (Profil-Tab in BottomNavigation)
  @override
  bool get wantKeepAlive => true;

  //  Bio-Dialog
  Future<void> _editBio() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditBioPage(currentBio: bio)),
    );

    if (result != null && result is String && result.trim().isNotEmpty) {
      setState(() => bio = result.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Bio updated'),
            backgroundColor: Color(0xFF1DB954),
          ),
        );
      }
    }
  }

  //  Login / Logout with AuthProvider
  Future<void> _toggleSpotifyLogin(AuthProvider auth) async {
    if (auth.isLoggedIn) {
      await auth.logout();
    } else {
      try {
        await auth.loginWithSpotify();
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); 

    final auth = context.watch<AuthProvider>();
    final currentUser = auth.displayName;
    final loggedIn = auth.isLoggedIn;

    //  Filter Feed-Posts for current user
    final userPosts =
        feedPosts.where((p) => p['user'] == currentUser).toList();

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

            // ───── Action Buttons ─────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Add Friend'),
                  style: _greyButtonStyle,
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _editBio,
                  icon: const Icon(Icons.edit),
                  label: const Text('Change Bio'),
                  style: _greyButtonStyle,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Spotify Login / Logout
            ElevatedButton.icon(
              onPressed: auth.isBusy ? null : () => _toggleSpotifyLogin(auth),
              icon: Icon(loggedIn ? Icons.logout : Icons.login),
              label: Text(loggedIn ? 'Logout Spotify' : 'Connect Spotify'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1DB954),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            if (auth.isBusy) const Padding(
              padding: EdgeInsets.only(top: 12),
              child: CircularProgressIndicator(),
            ),

            const SizedBox(height: 20),
            _buildFollowersRow(),
            const SizedBox(height: 24),

            // Bio
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF181818),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(bio,
                  style: const TextStyle(fontSize: 15, color: Colors.white)),
            ),
            const SizedBox(height: 24),

            // Activity Feed
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Activity',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            const SizedBox(height: 12),
            if (userPosts.isEmpty)
              const Text('You haven’t posted anything yet.',
                  style: TextStyle(color: Color(0xFFB3B3B3)))
            else
              ...userPosts.map((post) {
                final song = post['song'];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (_, a, __) =>
                        SongCommentsPage(song: song),
                    transitionsBuilder: (_, a, __, child) =>
                        FadeTransition(opacity: a, child: child),
                  )),
                  child: _buildActivityItem(
                    song['title'],
                    post['comment'],
                    (post['rating'] as num).toDouble(),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  // Followers / Following Dummy-Row
  Widget _buildFollowersRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _StatColumn(label: 'Following', value: '120'),
        _StatColumn(label: 'Followers', value: '88'),
      ],
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
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                Text(comment,
                    style: const TextStyle(color: Color(0xFFB3B3B3))),
              ],
            ),
          ),
          Text('${rating.toStringAsFixed(1)} ★',
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  ButtonStyle get _greyButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2A2A2A),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 0,
      );
}

/// Stat Column Widget
class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Color(0xFFB3B3B3))),
      ],
    );
  }
}

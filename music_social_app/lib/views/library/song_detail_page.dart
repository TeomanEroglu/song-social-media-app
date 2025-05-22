import 'package:flutter/material.dart';
import '../../data/feed_data.dart';

class SongDetailPage extends StatefulWidget {
  final Map<String, String> song;

  const SongDetailPage({super.key, required this.song});

  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  int rating = 3;
  final TextEditingController _commentController = TextEditingController();

  void _submitPost() {
    final comment = _commentController.text.trim();

    if (comment.isNotEmpty) {
      feedPosts.insert(0, {
        'song': widget.song,
        'rating': rating,
        'comment': comment,
        'timestamp': DateTime.now(),
        'user': 'Antonia',
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ Post published to feed')));

      _commentController.clear();
      Navigator.pop(context);
    }
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final filled = index < rating;
        return GestureDetector(
          onTap: () => setState(() => rating = index + 1),
          child: Icon(
            filled ? Icons.star_rounded : Icons.star_border_rounded,
            color: filled ? const Color(0xFF1DB954) : Colors.grey[700],
            size: 34,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.song;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(song['title'] ?? ''),
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        elevation: 0.3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/cover1.jpg',
              height: 220,
              width: 220,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            Text(
              song['title'] ?? '',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              song['artist'] ?? '',
              style: const TextStyle(fontSize: 15, color: Color(0xFFB3B3B3)),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF2A2A2A),
              ),
              child: const Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Your Rating:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            _buildStarRating(),

            const SizedBox(height: 30),

            TextField(
              controller: _commentController,
              maxLines: 2,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Your comment',
                hintStyle: const TextStyle(color: Color(0xFFB3B3B3)),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _submitPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1DB954),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                elevation: 0,
              ),
              child: const Text(
                'Post to Feed',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

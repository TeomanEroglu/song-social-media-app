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

    // Insert Logic (insert at top of feed)
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
      Navigator.pop(context); // Zurück zur Library oder Home
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
            color: filled ? Colors.amber : Colors.grey[400],
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
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(song['title'] ?? ''),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Coverbild (Aktuell statisch später dynamisch aus Spotify API)
            Image.asset(
              'assets/images/cover1.jpg', // später: song['image']
              height: 220,
              width: 220,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            // Song-Title/Artist
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

            const SizedBox(height: 24),

            // ▶Player (Dummy) -> Platzhalter für Spotify API-Player
            Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Icon(Icons.play_arrow_rounded, size: 32),
              ),
            ),

            const SizedBox(height: 30),

            // Bewertung
            const Text(
              'Your Rating:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildStarRating(),

            const SizedBox(height: 30),

            // Kommentar
            TextField(
              controller: _commentController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Your comment',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Post Button
            ElevatedButton(
              onPressed: _submitPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8E6F7),
                foregroundColor: const Color(0xFF2F2F2F),
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

import 'package:spotify/spotify.dart' hide Album;
import 'package:spotify/spotify.dart' show Track;
import '../services/spotify_auth_service.dart';


/// Lightweight domain model the UI can consume without depending on the
/// `spotify` package classes (makes testing & serialization easier).
class Song {
  final String id;
  final String title;
  final String artist;
  final String? albumImageUrl;
  final String? previewUrl;   // 30‑sec preview (can be null)
  final Duration duration;
  final String uri;           // e.g. spotify:track:...

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumImageUrl,
    required this.previewUrl,
    required this.duration,
    required this.uri,
  });
}

/// Repository that hides the Spotify API implementation details and returns
/// simple [Song] objects.
class SpotifySongRepository {
  /// Searches for tracks by [query]. Supports pagination via [offset] & [limit]
  /// (Spotify max = 50). Throws any [Exception] up to the caller.
  Future<List<Song>> fetchSongs(
    String query, {
    int offset = 0,
    int limit = 20,
  }) async {
    
      final api = await SpotifyAuthService().connect();

      // Perform the search. We request only tracks for now.
      final pages = api.search.get(
        query,
        types: [SearchType.track],
      );

      // Extract tracks; the package returns a wrapper object.
      final firstPages = await pages.first(limit);
      final trackItems = firstPages
          .expand((page) => (page.items ?? []).cast<Track>())
          .toList();

      return trackItems.map<Song>((t) {
        final firstArtist = t.artists?.isNotEmpty == true ? t.artists!.first.name : 'Unknown';
        return Song(
          id: t.id!,
          title: t.name ?? 'Untitled',
          artist: firstArtist ?? 'Unknown',
          albumImageUrl: t.album?.images?.isNotEmpty == true ? t.album!.images!.first.url : null,
          previewUrl: t.previewUrl,
          duration: Duration(milliseconds: t.durationMs ?? 0),
          uri: t.uri ?? '',
        );
      }).toList();
    
  }
  
}

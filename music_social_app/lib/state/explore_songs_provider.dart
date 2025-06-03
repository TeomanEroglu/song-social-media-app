import 'package:flutter/foundation.dart';
import '../services/spotify_song_repository.dart';

/// Holds loading / data / error state for the Explore page.
/// Uses [SpotifySongRepository] to fetch tracks.
class ExploreSongsProvider extends ChangeNotifier {
  // ── öffentlicher State ────────────────────────────────────────────────
  bool isLoading = false;
  String? error;
  List<Song> songs = [];

  // ── interne Helfer ────────────────────────────────────────────────────
  final SpotifySongRepository _repo = SpotifySongRepository();
  static const int _pageSize = 50;

  int _offset = 0;
  String _currentQuery = 'test';      // Default-Suchbegriff

  // ── API ───────────────────────────────────────────────────────────────
  /// Lädt die erste Seite für [query] (Standard = 'test') und setzt den UI-State.
  Future<void> loadInitial([String query = 'test']) async {
    _currentQuery = query;
    _offset = 0;

    isLoading = true;
    error = null;
    songs = [];
    notifyListeners();

    try {
      final result = await _repo.fetchSongs(
        _currentQuery,
        offset: _offset,
        limit: _pageSize,
      );
      songs = result;
      _offset += result.length;
    } catch (e, st) {
      error = e.toString();
      debugPrintStack(stackTrace: st, label: 'ExploreSongsProvider.loadInitial');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Lädt die nächste Seite für die aktuell gesetzte Suche.
  Future<void> loadMore() async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final result = await _repo.fetchSongs(
        _currentQuery,
        offset: _offset,
        limit: _pageSize,
      );
      songs.addAll(result);
      _offset += result.length;
    } catch (e, st) {
      error = e.toString();
      debugPrintStack(stackTrace: st, label: 'ExploreSongsProvider.loadMore');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  /// Setzt den State auf „leer“ ohne Fehler.
  void reset() {
    isLoading = false;
    error = null;
    songs = [];
    notifyListeners();
  }


  /// Pull-to-Refresh: lädt dieselbe Suche erneut.
  Future<void> refresh() => loadInitial(_currentQuery);
}

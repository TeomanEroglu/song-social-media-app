import 'package:flutter/foundation.dart';
import '../services/spotify_song_repository.dart';

/// Holds loading / data / error state for the Explore page.
/// Uses [SpotifySongRepository] to fetch tracks.
class ExploreSongsProvider extends ChangeNotifier {
  // ── public state -----------------------------------------------------------
  bool isLoading = false;
  String? error;
  List<Song> songs = [];

  /// Singleton instance for easy access in the app.
  final SpotifySongRepository _repo = SpotifySongRepository();
  static const int _pageSize = 50;

  int _offset = 0;
  String _currentQuery = 'test';      

  // ── API ───────────────────────────────────────────────────────────────
  /// Loads the first page for [query] (default = 'test') and sets the UI state.
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

 /// Loads the next page for the currently active search.
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
  /// Sets the state to "empty" without errors.
  void reset() {
    isLoading = false;
    error = null;
    songs = [];
    notifyListeners();
  }


  /// Pull-to-Refresh: loads same site again.
  Future<void> refresh() => loadInitial(_currentQuery);
}

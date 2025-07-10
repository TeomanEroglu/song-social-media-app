import 'package:flutter/foundation.dart';
import '../services/spotify_auth_service.dart';

/// Global Auth-Status 
/// * isLoggedIn – Spotify-Login successful
/// * isGuest    – User is in Guest-Modus (no Spotify-Login)
/// * displayName – Spotifyname of the logged-in user or 'Guest'
class AuthProvider extends ChangeNotifier {
  // ── private ----------------------------------------------------------------
  bool _isLoggedIn = false;
  bool _isGuest = false;
  bool _isBusy = false;
  String? _displayName;

  // ── public getter ----------------------------------------------------------
  bool get isLoggedIn => _isLoggedIn;
  bool get isGuest => _isGuest;
  bool get isBusy => _isBusy;
  String get displayName => _displayName ?? 'Guest';

  // ── restore Session --------------------------------------------------------
  Future<void> restore() async {
    _isBusy = true;
    notifyListeners();

    try {
      if (await SpotifyAuthService().isLoggedIn()) {
        final api = await SpotifyAuthService().connect();
        final me = await api.me.get();
        _isLoggedIn = true;
        _displayName = me.displayName ?? 'Unknown';
      }
    } catch (e) {
      debugPrint('AuthProvider.restore – $e');
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  // ── Spotify-Login ----------------------------------------------------------
  Future<void> loginWithSpotify() async {
    _isBusy = true;
    notifyListeners();

    try {
      final api = await SpotifyAuthService().connect();
      final me = await api.me.get();

      _isLoggedIn = true;
      _isGuest = false;
      _displayName = me.displayName ?? 'Unknown';
    } catch (e) {
      debugPrint('AuthProvider.loginWithSpotify – $e');
      rethrow; 
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  // ── Guest-Mode -------------------------------------------------------------
  void continueAsGuest() {
    _isGuest = true;
    _isLoggedIn = false;
    _displayName = 'Guest';
    notifyListeners();
  }

  // ── Logout -----------------------------------------------------------------
  Future<void> logout() async {
    await SpotifyAuthService().logout();
    _isLoggedIn = false;
    _isGuest = false;
    _displayName = 'Guest';
    notifyListeners();
  }
}

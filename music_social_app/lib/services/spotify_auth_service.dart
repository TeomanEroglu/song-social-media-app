import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:oauth2_client/interfaces.dart';
import 'package:spotify/spotify.dart';

class SpotifyAuthService {
  // ──────────────────────────────────────
  // 1. Konstante Werte aus .env
  // ──────────────────────────────────────
  static final _clientId    = dotenv.env['SPOTIFY_CLIENT_ID']!;
  static final _redirectUri = dotenv.env['SPOTIFY_REDIRECT_URI']!;
  static final _scopes      = dotenv.env['SPOTIFY_SCOPES']!.split(',');

  // ──────────────────────────────────────
  // 2. Secure Storage für Token-Caching
  // ──────────────────────────────────────
  static const _secure = FlutterSecureStorage(); // AES-verschlüsselt auf Android/iOS

  // ──────────────────────────────────────
  // 3. OAuth2-Client & Helper
  // ──────────────────────────────────────
  static final _client = OAuth2Client(
    authorizeUrl: 'https://accounts.spotify.com/authorize',
    tokenUrl:     'https://accounts.spotify.com/api/token',
    redirectUri:  _redirectUri,
    customUriScheme: 'musicsocial',
  );

  late final OAuth2Helper _helper = OAuth2Helper(
    _client,
    clientId: _clientId,
    scopes: _scopes,
    // PKCE ist automatisch aktiv, weil kein Client-Secret angegeben wird
    tokenStorage: TokenStorage(                          // // persistiert Access + Refresh Token
      'spotify_tokens',                    // beliebiger Name
        //hier war:  storage: SecureStorage(storage: _secure), das hat nicht funktioneirt und Chat meinte man kann das weglassen
    ), 
  );

  // ──────────────────────────────────────
  // 4. Öffentliche API
  // ──────────────────────────────────────
  /// Liefert einen [SpotifyApi]-Client; loggt den User ein,
  /// wenn noch kein (gültiger) Token da ist.
  Future<SpotifyApi> connect() async {
    final token = await _helper.getToken(); // erneuert automatisch
    return SpotifyApi.withAccessToken(token!.accessToken!);
  }

  /// Beendet die Sitzung: Tokens löschen
  Future<void> logout() async => _helper.removeAllTokens();

  /// Gibt *true*, wenn ein gültiger Access-Token gespeichert ist.
  Future<bool> isLoggedIn() async =>
      (await _helper.getTokenFromStorage())?.isExpired() == false;
}

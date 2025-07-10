import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:oauth2_client/interfaces.dart';
import 'package:spotify/spotify.dart';

class SpotifyAuthService {
  //  constant values from .env
  static final _clientId    = dotenv.env['SPOTIFY_CLIENT_ID']!;
  static final _redirectUri = dotenv.env['SPOTIFY_REDIRECT_URI']!;
  static final _scopes      = dotenv.env['SPOTIFY_SCOPES']!.split(',');

  // 2. Secure Storage for Token-Caching
  static const _secure = FlutterSecureStorage(); 

  // 3. OAuth2-Client & Helper
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
    tokenStorage: TokenStorage(                           // persistiert Access + Refresh Token
      'spotify_tokens',                    
    ), 
  );

  // Public API
  /// Returns a [SpotifyApi] client; logs the user in if there isn’t a (valid) token yet.
  Future<SpotifyApi> connect() async {
    final token = await _helper.getToken(); 
    return SpotifyApi.withAccessToken(token!.accessToken!);
  }

  Future<void> logout() async => _helper.removeAllTokens();

  Future<bool> isLoggedIn() async =>
      (await _helper.getTokenFromStorage())?.isExpired() == false;
}

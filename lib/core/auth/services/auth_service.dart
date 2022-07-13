import 'package:flutter/services.dart';
import 'package:oauth2/oauth2.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_list/core/auth/models/auth_http_client.dart';
import 'package:to_do_list/core/auth/models/credentials_storage_base.dart';

class AuthService {
  // static properties
  static final authorizationEndpoint =
      Uri.parse('https://todoist.com/oauth/authorize');
  static final tokenEndpoint =
      Uri.parse('https://todoist.com/oauth/access_token');
  static final redirectUrl = Uri.parse('https://localhost:3000/redirect_url');
  static final revokeUrl =
      Uri.parse('https://api.todoist.com/sync/v8/access_tokens/revoke');
  static const clientId = 'e1f57971cf974348b6addfb6bc3522b0';
  static const secret = '729b9281b6684aad893379bf47930a7e';
  static const scopes = [
    'task:add',
    'data:read',
    'data:read_write',
    'data:delete'
  ];
  static const verificationToken = '17686_6eeaf1c36f7e8a696db14b20';
  static const testToken = '0e18dc7b5d90873ec7b903ba4b8450878bf95964';

  // private properties
  late final CredentialsStorageBase _storage;

  AuthService(this._storage);

  Future<Credentials?> getSignedInCredentials() async {
    try {
      final storedCreds = await _storage.read();
      // if (storedCreds != null) {
      //   if (storedCreds.canRefresh && storedCreds.isExpired) {
      //     final refreshResult = await refresh(storedCreds);
      //     return refreshResult.fold(
      //             (authFailure) => null, (newCredentials) => newCredentials);
      //   }
      // }
      return storedCreds;
    } on PlatformException {
      return null;
    }
  }

  Future<bool> isSignedIn() =>
      getSignedInCredentials().then((value) => value != null);

  Stream<Credentials?> getSignedInCredentialsStream() async* {
    try {
      final storedCreds = await _storage.read();
      // if (storedCreds != null) {
      //   if (storedCreds.canRefresh && storedCreds.isExpired) {
      //     final refreshResult = await refresh(storedCreds);
      //     return refreshResult.fold(
      //             (authFailure) => null, (newCredentials) => newCredentials);
      //   }
      // }
      yield storedCreds;
    } on PlatformException {
      yield null;
    }
  }

  Stream<bool> isSignedInStream() =>
      getSignedInCredentialsStream().map((event) => event != null);

  AuthorizationCodeGrant createGrant() {
    return AuthorizationCodeGrant(
        clientId, authorizationEndpoint, tokenEndpoint,
        secret: secret, delimiter: ',', httpClient: AuthHttpClient());
  }

  Uri getAuthorizationUrl(AuthorizationCodeGrant grant) {
    return grant.getAuthorizationUrl(redirectUrl,
        scopes: scopes, state: 'todoist');
  }

  Future<bool> handleAuthorizationResponse(
      AuthorizationCodeGrant grant, Map<String, String> queryParams) async {
    try {
      final httpClient = await grant.handleAuthorizationResponse(queryParams);
      await _storage.write(httpClient.credentials);
      return true;
    } on FormatException {
      throw Exception('Format Exception Error');
    } on AuthorizationException catch (e) {
      throw Exception('${e.error}: ${e.description}');
    } on PlatformException {
      throw Exception('Platform Exception');
    }
  }

  Future<bool> signOut() async {
    try {
      final accessToken =
          await _storage.read().then((value) => value?.accessToken);
      http.Response signOutResponse = await http.post(revokeUrl, headers: {
        'Content-Type': 'application/json'
      }, body: {
        "client_id": clientId,
        "client_secret": secret,
        "access_token": accessToken
      });
      if (signOutResponse.statusCode != 0) {
        await _storage.clear();
        return true;
      }
      return throw Exception('Platform Exception');
    } on PlatformException {
      throw Exception('Platform Exception');
    }
  }
}

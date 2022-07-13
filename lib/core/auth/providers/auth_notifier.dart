import 'package:flutter/material.dart';
import 'package:to_do_list/core/auth/services/auth_service.dart';

class _AuthState {
  bool get isInitial => _isInitial;
  bool _isInitial = true;

  bool get isAuthenticated => _isAuthenticated;

  set isAuthenticated(bool isUserSignedIn) {
    _isInitial = false;
    _isAuthenticated = isUserSignedIn;
  }

  bool _isAuthenticated = false;

  bool get hasError => _hasError;
  bool _hasError = false;

  String get errorMessage => _errorMessage;

  set errorMessage(String errorMsg) {
    _isInitial = false;
    _hasError = true;
    _errorMessage = errorMsg;
  }

  String _errorMessage = '';

  bool get isLoading => _isLoading;

  set isLoading(bool isLoading) {
    _isInitial = false;
    _isLoading = isLoading;
  }

  bool _isLoading = false;

  _AuthState._();

  _AuthState.initial() {
    _isInitial = true;
    _isLoading = false;
    _isAuthenticated = false;
    _hasError = false;
    _errorMessage = '';
  }
}

typedef AuthUriCallback = Future<Uri> Function(Uri authorizationUrl);
typedef AuthUriCallbackStream = Stream<Uri> Function(Uri authorizationUrl);

class AuthNotifier extends ChangeNotifier {
  AuthService? _authService;

  _AuthState get authState => _state;
  final _AuthState _state = _AuthState.initial();

  AuthNotifier();

  void initNotifier(AuthService authService) {
    _authService = authService;
  }

  void checkAndUpdateAuthStatus() {
    _state.isLoading = true;
    _authService?.isSignedIn().then((isSignedIn) {
      _state.isAuthenticated = isSignedIn;
      _state.isLoading = false;
      notifyListeners();
    }).catchError((error) {
      _state.errorMessage = error.toString();
      _state.isLoading = false;
      notifyListeners();
    });
  }

  void checkAndUpdateAuthStatusStream() {
    _state.isLoading = true;
    _authService?.isSignedInStream().listen((isSignedIn) {
      _state.isAuthenticated = isSignedIn;
      _state.isLoading = false;
      notifyListeners();
    }).onError((error) {
      _state.errorMessage = error.toString();
      _state.isLoading = false;
      notifyListeners();
    });
  }

  void signIn(AuthUriCallback authorizationCallback) async {
    final grant = _authService?.createGrant();
    if (grant == null) {
      _state.errorMessage = 'Error while creating grant';
      return notifyListeners();
    }
    try {
      final redirectUrl =
          await authorizationCallback(_authService!.getAuthorizationUrl(grant));
      debugPrint('redirect URL from signIn notifier: ${redirectUrl.toString()}');

      final authResult = await _authService?.handleAuthorizationResponse(
          grant, redirectUrl.queryParameters);
      _state.isAuthenticated = authResult == true;
      debugPrint(_state.isAuthenticated.toString());
      notifyListeners();
    } catch (e) {
      _state.errorMessage = e.toString();
      notifyListeners();
    }
    grant.close();
  }

  void signInStream(AuthUriCallbackStream authorizationCallback) {
    final grant = _authService?.createGrant();
    bool isGrantClosed = false;
    if (grant == null) {
      _state.errorMessage = 'Error while creating grant';
      return notifyListeners();
    }
    authorizationCallback(_authService!.getAuthorizationUrl(grant))
        // .takeWhile((_) => !isGrantClosed)
        .listen((Uri url) async {
      final authResult = await _authService?.handleAuthorizationResponse(
          grant, url.queryParameters);
      _state.isAuthenticated = authResult == true;
      grant.close();
      isGrantClosed = true;
      notifyListeners();
    }).onError((error) {
      _state.errorMessage = error.toString();
      grant.close();
      isGrantClosed = true;
      notifyListeners();
    });
  }

  void signOut() async {
    try {
      final signOutRes = await _authService?.signOut();
      if (signOutRes == null) throw Exception('Error while signing out');
      _state.isAuthenticated = !signOutRes;
    } catch (e) {
      _state.errorMessage = e.toString();
    }
    notifyListeners();
    return;
  }
}

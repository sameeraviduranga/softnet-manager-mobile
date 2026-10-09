import 'package:flutter/foundation.dart';

class AuthSessionmanager extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isInitialized = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isInitialized => _isInitialized;

  void authenticated() {
    _isAuthenticated = true;
    _isInitialized = true;
    notifyListeners();
  }

  void unauthenticated() {
    _isAuthenticated = false;
    _isInitialized = true;
    notifyListeners();
  }
}

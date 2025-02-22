import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  String? _token;

  User? get currentUser => _currentUser;
  String? get token => _token;
  int? get currentUserId => _currentUser?.userId;

  void setUserAndToken(User user, String token) {
    _currentUser = user;
    _token = token;
    ApiService().setToken(token);
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    _token = null;
    ApiService().setToken(null);
    notifyListeners();
  }
} 
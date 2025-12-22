import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _user;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get user => _user;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    
    if (userData != null) {
      _user = {
        'email': userData,
        'name': userData.split('@')[0],
      };
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password, bool rememberMe) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Mock authentication - in real app, call your API
      if (email.isNotEmpty && password.isNotEmpty) {
        _user = {
          'email': email,
          'name': email.split('@')[0],
        };
        _isAuthenticated = true;

        // Save user data
        final prefs = await SharedPreferences.getInstance();
        if (rememberMe) {
          await prefs.setString('user', email);
        } else {
          await prefs.setString('user_session', email);
        }
      } else {
        _errorMessage = 'Invalid email or password';
      }
    } catch (e) {
      _errorMessage = 'Login failed. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Mock registration - in real app, call your API
      if (email.isNotEmpty && password.length >= 6) {
        _user = {
          'email': email,
          'name': email.split('@')[0],
        };
        _isAuthenticated = true;

        // Save user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', email);
      } else {
        _errorMessage = 'Please provide valid email and password (min 6 characters)';
      }
    } catch (e) {
      _errorMessage = 'Registration failed. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _user = null;
    _errorMessage = null;

    // Clear stored data
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('user_session');
    
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

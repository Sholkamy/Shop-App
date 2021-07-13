import 'dart:async';
import 'dart:convert';
import 'package:e_commerce_app/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

const String apiKey = 'AIzaSyAQsZEldYYxWbb9Nr1tLhXX1eecost8nbo';
const String url = 'https://identitytoolkit.googleapis.com/v1/accounts';

class Auth with ChangeNotifier {
  String token;
  DateTime expiryDate;
  String userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get tokenMethod {
    if (expiryDate != null &&
        expiryDate.isAfter(DateTime.now()) &&
        token != null) {
      return token;
    }
    return null;
  }

  String get userIdMethod {
    return userId;
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    try {
      final authenticateUrl = Uri.parse('$url:$urlSegment?key=$apiKey');
      final response = await http.post(
        authenticateUrl,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null)
        throw HttpException(responseData['error']['message']);
      token = responseData['idToken'];
      userId = responseData['localId'];
      expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': token,
        'userId': userId,
        'expiryDate': expiryDate.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final prefsExpiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (prefsExpiryDate.isBefore(DateTime.now())) {
      return false;
    }

    token = extractedUserData['token'];
    userId = extractedUserData['userId'];
    expiryDate = prefsExpiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> signUp(String email, String password) {
    return authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) {
    return authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    token = null;
    expiryDate = null;
    userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}

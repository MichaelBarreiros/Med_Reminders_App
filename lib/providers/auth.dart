import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:med_reminders_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }

    return null;
  }

  Future<void> _authenticate(
      String? email, String? password, String urlSegment) async {
    Uri url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBTB5rk2U1kZyUqK0WXdYOkVVoHcJHGcRs");
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      if (json.decode(response.body)['error'] != null) {
        throw HttpException(json.decode(response.body)['error']['message']);
      }

      _token = json.decode(response.body)['idToken'];
      _userId = json.decode(response.body)['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(json.decode(response.body)['expiresIn'])),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String? email, String? password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String? email, String? password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
  }
}

import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_guide_rental/models/AppConstants.dart';
import 'package:tour_guide_rental/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  String _roleId;
  Timer _authTimer;
  String _fullName;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  String get roleId {
    return _roleId;
  }

  String get fullName {
    return _fullName;
  }

  Future<void> signup(
    String email,
    String password,
    String fullname,
    String role,
  ) async {
    final url = AppConstants.urlApi + 'doRegist';
    print(url);
    print(email);
    print(password);
    print(fullname);
    try {
      final response = await http.post(
        url,
        body: {
          'full_name': fullname,
          'email': email,
          'password': password,
          'role': '3',
        },
      );

      print(json.decode(response.body));
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    final url = AppConstants.urlApi + 'doLogin';
    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );
      final responseData = json.decode(response.body);

      if (responseData['statusCode'] == 0) {
        throw HttpException(responseData['data']);
      }

      _token = responseData['data']['id'].toString();
      _userId = responseData['data']['id'].toString();
      _roleId = responseData['data']['role_id'].toString();
      _fullName = responseData['data']['full_name'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: 3600,
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'roleId': _roleId,
          'userId': _userId,
          'fullName': _fullName,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
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
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _roleId = extractedUserData['roleId'];
    _fullName = extractedUserData['fullName'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _roleId = null;
    _fullName = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> isiSaldo(String saldo) async {
    final url = AppConstants.urlApi + 'user/' + _userId + '/topupSaldo';
    try {
      final response = await http.post(
        url,
        body: {
          'topup': saldo,
        },
      );
      final responseData = json.decode(response.body);

      if (responseData['statusCode'] == 0) {
        throw HttpException(responseData['data']);
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> editProfile(
    String email,
    String emailOld,
    String fullName,
    String password,
    String noHp,
    String address,
    String dateBirth,
    String image,
  ) async {
    final url = AppConstants.urlApi + 'user/' + _userId + '/editProfile';
    try {
      final response = await http.put(
        url,
        body: {
          'email': email,
          'email_old': emailOld,
          'full_name': fullName,
          'password': password,
          'no_hp': noHp,
          'alamat': address,
          'date_birth': dateBirth,
          'image': image,
        },
      );
      final responseData = json.decode(response.body);

      if (responseData['statusCode'] == 0) {
        throw HttpException(responseData['data']);
      }

      print(responseData);

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tour_guide_rental/models/AppConstants.dart';

class Account {
  final String id;
  final String email;
  final String name;
  final String saldo;
  final String hp;
  final String birthDate;
  final String address;
  final String image;

  Account({
    @required this.id,
    @required this.email,
    @required this.name,
    @required this.saldo,
    @required this.hp,
    @required this.birthDate,
    @required this.address,
    @required this.image,
  });
}

class UserData with ChangeNotifier {
  Account _user;
  final String userId;

  UserData(this.userId, this._user);

  Account get user {
    return _user;
  }

  Future<void> fetchAndSetUser() async {
    final url = AppConstants.urlApi + 'user/' + userId + '/viewProfile';
    final response = await http.get(url);
    final extractedData = json.decode(response.body);
    if (extractedData['data'] == "Data Tidak Ditemukan") {
      return;
    }
    _user = Account(
      id: extractedData['data']['id'].toString(),
      email: extractedData['data']['email'],
      name: extractedData['data']['full_name'],
      saldo: extractedData['data']['saldo'],
      hp: extractedData['data']['no_hp'],
      birthDate: extractedData['data']['date_birth'],
      address: extractedData['data']['alamat'],
      image: extractedData['data']['image'],
    );
    notifyListeners();
  }
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tour_guide_rental/models/AppConstants.dart';
import 'package:tour_guide_rental/models/http_exception.dart';
import 'package:tour_guide_rental/providers/auth.dart';

class PemanduOrderItem {
  final String id;
  final String userId;
  final String museumId;
  final String museumName;
  final String museumPrice;
  final String museumImage;
  final String wisatawanName;
  final String status;
  final DateTime dateTime;
  final String messageID;

  PemanduOrderItem({
    @required this.id,
    @required this.userId,
    @required this.museumId,
    @required this.museumName,
    @required this.museumPrice,
    @required this.museumImage,
    @required this.wisatawanName,
    @required this.status,
    @required this.dateTime,
    @required this.messageID,
  });
}

class PemanduOrders with ChangeNotifier {
  List<PemanduOrderItem> _orders = [];

  final String userId;

  PemanduOrders(this.userId, this._orders);

  List<PemanduOrderItem> get orders {
    return [..._orders];
  }

  PemanduOrderItem findById(String id) {
    return _orders.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetOrders() async {
    final url = AppConstants.urlApi + 'pemandu/' + userId + '/historyOrder';
    final response = await http.get(url);
    final List<PemanduOrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData['data'] == "Data Tidak Ditemukan") {
      return;
    }
    extractedData['data'].forEach((orderData) {
      loadedOrders.add(
        PemanduOrderItem(
          id: orderData['id'].toString(),
          userId: orderData['pelanggan_id'].toString(),
          museumId: orderData['museum_id'].toString(),
          museumName: orderData['museum']['museum_name'],
          museumPrice: orderData['museum']['museum_price'],
          museumImage: orderData['museum']['museum_image'],
          wisatawanName: orderData['wisatawan']['full_name'],
          messageID: orderData['message_id'],
          status: orderData['status'],
          dateTime: DateTime.parse(orderData['created_at']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> changeStatus(String status) async {
    final url = AppConstants.urlApi + 'pemandu/' + userId + '/changeStatus';

    try {
      final response = await http.put(
        url,
        body: {
          'status': status,
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] == 0) {
        throw HttpException(responseData['data']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> accept(String id, DocumentSnapshot snapshot) async {
    final url = AppConstants.urlApi + 'order/' + id + '/acceptOrder';

    Map<String, dynamic> data = {
      'status': '2',
    };

    try {
      final response = await http.put(url);

      await Firestore.instance
          .document('orders/${snapshot.documentID}')
          .updateData(data);

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] == 0) {
        throw HttpException(responseData['data']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> cancel(String id, DocumentSnapshot snapshot) async {
    final url = AppConstants.urlApi + 'order/' + id + '/cancelOrder';

    Map<String, dynamic> data = {
      'status': '-1',
    };

    try {
      final response = await http.put(url);

      await changeStatus('1');

      await Firestore.instance
          .document('orders/${snapshot.documentID}')
          .updateData(data);

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] == 0) {
        throw HttpException(responseData['data']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> finish(String id) async {
    final url = AppConstants.urlApi + 'order/' + id + '/finishOrder';

    Map<String, dynamic> data = {
      'status': '1',
    };

    try {
      final response = await http.put(url);

      final responseData = json.decode(response.body);
      if (responseData['statusCode'] == 0) {
        throw HttpException(responseData['data']);
      }
    } catch (e) {
      throw e;
    }
  }
}

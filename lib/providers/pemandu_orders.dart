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
  final String idFirebase;
  final String wisatawanName;
  final String museumName;
  final String museumPrice;
  final DateTime dateTime;

  PemanduOrderItem({
    this.id,
    this.idFirebase,
    this.wisatawanName,
    this.museumName,
    this.museumPrice,
    this.dateTime,
  });
}

class PemanduOrders with ChangeNotifier {
  PemanduOrderItem _orders;

  final String userId;

  PemanduOrders(this.userId, this._orders);

  PemanduOrderItem get orders {
    return _orders;
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
}

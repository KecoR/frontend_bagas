import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tour_guide_rental/models/AppConstants.dart';
import 'package:tour_guide_rental/models/http_exception.dart';

class OrderItem {
  final String id;
  final String userId;
  final String museumId;
  final String museumName;
  final String museumPrice;
  final String museumImage;
  final String pemanduName;
  final String status;
  final double rating;
  final DateTime dateTime;
  final String messageID;

  OrderItem({
    @required this.id,
    @required this.userId,
    @required this.museumId,
    @required this.museumName,
    @required this.museumPrice,
    @required this.museumImage,
    @required this.pemanduName,
    @required this.status,
    @required this.rating,
    @required this.dateTime,
    @required this.messageID,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String userId;

  Orders(this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  OrderItem findById(String id) {
    return _orders.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetOrders() async {
    final url = AppConstants.urlApi + 'user/' + userId + '/historyOrder';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData['data'] == "Data Tidak Ditemukan") {
      return;
    }
    extractedData['data'].forEach((orderData) {
      double _rating;
      if (orderData['rating'] != null) {
        _rating = double.parse(orderData['rating']);
      }
      loadedOrders.add(
        OrderItem(
          id: orderData['id'].toString(),
          userId: orderData['pelanggan_id'].toString(),
          museumId: orderData['museum_id'].toString(),
          museumName: orderData['museum']['museum_name'],
          museumPrice: orderData['museum']['museum_price'],
          museumImage: orderData['museum']['museum_image'],
          pemanduName: orderData['pemandu']['full_name'],
          messageID: orderData['message_id'],
          rating: _rating,
          status: orderData['status'],
          dateTime: DateTime.parse(orderData['created_at']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> giveRating(orderId, rating) async {
    final url = AppConstants.urlApi + 'order/' + orderId + '/giveMuseumRating';
    try {
      final response = await http.put(
        url,
        body: {
          'rating': rating.toString(),
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] == 0) {
        throw HttpException(responseData['data']);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> orderPemandu(museumId) async {
    final url = AppConstants.urlApi + 'user/' + userId + '/orderPemandu';
    try {
      final response = await http.post(
        url,
        body: {
          'museum_id': museumId,
        },
      );
      final responseData = json.decode(response.body);

      print(responseData);

      if (responseData['statusCode'] == 0) {
        throw HttpException(responseData['data']);
      } else {
        List<String> userNames = [
          responseData['data']['pemandu']['full_name'],
          responseData['data']['wisatawan']['full_name'],
        ];

        List<String> userIDs = [
          responseData['data']['pemandu']['id'].toString(),
          responseData['data']['wisatawan']['id'].toString(),
        ];

        Map<String, dynamic> convoData = {
          'lastMessageDateTime': DateTime.now(),
          'lastMessageText': "",
          'userNames': userNames,
          'userIDs': userIDs,
        };

        DocumentReference reference =
            await Firestore.instance.collection('conversations').add(convoData);

        Map<String, dynamic> order = {
          'dateTime': DateTime.now(),
          'museumName': responseData['data']['museum']['museum_name'],
          'museumPrice': responseData['data']['museum']['museum_price'],
          'museumImage': responseData['data']['museum']['museum_image'],
          'orderIDs': responseData['data']['id'].toString(),
          'pemanduIDs': responseData['data']['pemandu']['id'].toString(),
          'wisatawanIDs': responseData['data']['wisatawan']['id'].toString(),
          'wisatawanName': responseData['data']['wisatawan']['full_name'],
          'status': '0',
          'messageIDs': reference.documentID,
        };

        await Firestore.instance.collection('orders').add(order);

        final urlMessage = AppConstants.urlApi +
            'order/' +
            responseData['data']['id'].toString() +
            '/editMessageID';

        await http.put(
          urlMessage,
          body: {
            'message_id': reference.documentID,
          },
        );
      }
    } catch (e) {
      throw e;
    }
  }
}

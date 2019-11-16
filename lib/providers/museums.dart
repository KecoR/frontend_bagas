import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:tour_guide_rental/models/AppConstants.dart';

import 'package:http/http.dart' as http;

import './museum.dart';

class Museums with ChangeNotifier {
  List<Museum> _items = [];

  // var _showFavoriteOnly = false;
  Museums(this._items);

  List<Museum> get items {
    // if (_showFavoriteOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }

    return [..._items];
  }

  List<Museum> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Museum findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts() async {
    final url = AppConstants.urlApi + 'museum';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      // print(extractedData['data']);
      final List<Museum> loadedMuseums = [];
      extractedData['data'].forEach((museumData) {
        loadedMuseums.add(Museum(
          id: museumData['id'].toString(),
          museumName: museumData['museum_name'],
          museumDesc: museumData['museum_desc'],
          museumRating: museumData['museum_rating'],
          museumPrice: double.parse(museumData['museum_price']),
          museumImage: museumData['museum_image'],
        ));
      });
      _items = loadedMuseums;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void addMuseum() {
    // _items.add(value);
    notifyListeners();
  }
}

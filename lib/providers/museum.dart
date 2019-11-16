import 'package:flutter/foundation.dart';

class Museum with ChangeNotifier {
  final String id;
  final String museumName;
  final String museumDesc;
  final String museumImage;
  final String museumRating;
  final double museumPrice;
  bool isFavorite;

  Museum({
    @required this.id,
    @required this.museumName,
    @required this.museumDesc,
    @required this.museumRating,
    @required this.museumPrice,
    @required this.museumImage,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}

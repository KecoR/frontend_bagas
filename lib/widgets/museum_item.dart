import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_rental/models/AppConstants.dart';

import '../screens/museum_detail_screen.dart';
import '../providers/museum.dart';

class MuseumItem extends StatelessWidget {
  // final String id;
  // final String museum_name;
  // final String museum_image;
  // final String museum_rating;

  // MuseumItem(this.id, this.museum_name, this.museum_image, this.museum_rating);

  @override
  Widget build(BuildContext context) {
    final museum = Provider.of<Museum>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        header: GridTileBar(
          backgroundColor: Colors.black26,
          title: Padding(
            padding: const EdgeInsets.all(0),
            child: Text(
              museum.museumName,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              MuseumDetailScreen.routeName,
              arguments: museum.id,
            );
          },
          child: Image.network(
            AppConstants.urlImage + museum.museumImage,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          // leading: Consumer<Museum>(
          //   builder: (ctx, museum, _) => IconButton(
          //     icon: Icon(
          //       museum.isFavorite ? Icons.favorite : Icons.favorite_border,
          //     ),
          //     color: Theme.of(context).accentColor,
          //     onPressed: () {
          //       museum.toggleFavoriteStatus();
          //     },
          //   ),
          //   // child: ,
          // ),
          title: Text(
            museum.museumRating != null
                ? museum.museumRating + "/100"
                : '0' + "/100",
            textAlign: TextAlign.center,
          ),
          // trailing: IconButton(
          //   icon: Icon(
          //     Icons.shopping_cart,
          //   ),
          //   color: Theme.of(context).accentColor,
          //   onPressed: () {},
          // ),
        ),
      ),
    );
  }
}

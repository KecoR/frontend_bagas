import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/museums.dart';
import './museum_item.dart';

class MuseumsGrid extends StatelessWidget {
  final bool showFavs;

  MuseumsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final museumData = Provider.of<Museums>(context);
    final museums = showFavs ? museumData.favoriteItems : museumData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: museums.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // builder: (c) => museums[i],
        value: museums[i],
        child: MuseumItem(
            // museums[i].id,
            // museums[i].museum_name,
            // museums[i].museum_image,
            // museums[i].museum_rating,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

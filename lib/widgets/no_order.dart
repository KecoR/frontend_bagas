import 'package:flutter/material.dart';
import 'package:tour_guide_rental/helpers/buttons.dart';

class NoOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Hai Pemandu',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Finding a Tourist',
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          CircularProgressIndicator(),
          SizedBox(
            height: 20.0,
          ),
          froyoFlatBtn(
            'Cancel',
            () {
              // _cancel();
            },
          ),
        ],
      ),
    );
  }
}

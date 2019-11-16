import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tour_guide_rental/helpers/styles.dart';
import 'package:tour_guide_rental/models/AppConstants.dart';

class PemanduGrid extends StatelessWidget {
  String _text;
  String _userId;
  String _statusNum;

  PemanduGrid(this._text, this._userId, this._statusNum);

  @override
  Widget build(BuildContext context) {
    if (_statusNum == '1') {
      print(_userId);
      return StreamBuilder(
        stream: Firestore.instance
            .collection('orders')
            .where('pemanduIDs', arrayContains: _userId)
            .snapshots(),
        builder: (ctx, snapshots) {
          if (snapshots.hasData) {
            return ListView.builder(
              itemCount: snapshots.data.documents.length,
              itemExtent: MediaQuery.of(context).size.height / 9,
              itemBuilder: (context, index) {
                DocumentSnapshot snapshot = snapshots.data.documents[index];
                print(snapshot.data.toString());
                return InkResponse(
                  child: ListTile(
                    title: Text(snapshot.data.toString()),
                  ),
                );
              },
            );
          } else {
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
                    _text,
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      );
    } else {
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
              _text,
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      );
    }
  }
}

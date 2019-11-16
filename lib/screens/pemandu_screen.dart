import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_rental/helpers/buttons.dart';
import 'package:tour_guide_rental/models/http_exception.dart';
import 'package:tour_guide_rental/providers/auth.dart';
import 'package:tour_guide_rental/providers/pemandu_orders.dart';
import 'package:tour_guide_rental/screens/pemandu_order_screen.dart';
import 'package:tour_guide_rental/widgets/pemandu_drawer.dart';
import 'package:tour_guide_rental/widgets/pemandu_grid.dart';
import 'package:tour_guide_rental/widgets/pemandu_order.dart';

class PemanduScreen extends StatefulWidget {
  @override
  _PemanduScreenState createState() => _PemanduScreenState();

  static const routeName = '/pemandu';
}

class _PemanduScreenState extends State<PemanduScreen> {
  String _userId;
  String _fullName;
  int _status = 0;
  bool _value = false;
  String _statusNum = '';
  String _text = '';

  void _findTourist() async {
    try {
      Navigator.of(context).pushNamed(
        PemanduOrderScreen.routeName,
      );
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      print(error.toString());
      var errorMessage = 'Connection Error. Please try again later.';
      _showErrorDialog(errorMessage);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay!'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _changeStatus(bool _newStat) async {
    if (_newStat) {
      setState(() {
        _value = true;
        _statusNum = '1';
        _text = 'Finding a Tourist';
      });
      await Provider.of<PemanduOrders>(context).changeStatus(_statusNum);
    } else {
      setState(() {
        _value = false;
        _statusNum = '0';
        _text = '';
      });
      await Provider.of<PemanduOrders>(context).changeStatus(_statusNum);
    }
  }

  @override
  Widget build(BuildContext context) {
    _userId = Provider.of<PemanduOrders>(context).userId;
    _fullName = Provider.of<Auth>(context).fullName;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Pemandu',
        ),
        actions: <Widget>[
          new Switch(
            value: _value,
            onChanged: (bool _newStat) {
              _changeStatus(_newStat);
            },
          ),
        ],
      ),
      drawer: PemanduDrawer(),
      body: _value
          ? StreamBuilder(
              stream: Firestore.instance
                  .collection("orders")
                  .where('pemanduIDs', isEqualTo: _userId)
                  .snapshots(),
              builder: (context, snapshots) {
                if (snapshots.hasData) {
                  for (int i = 0; i < snapshots.data.documents.length; i++) {
                    DocumentSnapshot snapshot = snapshots.data.documents[i];
                    if (snapshot['status'] == '0') {
                      return PemanduOrder(snapshot);
                    }
                  }
                  return NoOrder();
                } else {
                  return NoOrder();
                }
              },
            )
          : Center(
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
                ],
              ),
            ),
    );
  }
}

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
        ],
      ),
    );
  }
}

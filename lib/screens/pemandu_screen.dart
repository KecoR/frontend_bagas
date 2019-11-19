import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_rental/helpers/buttons.dart';
import 'package:tour_guide_rental/helpers/styles.dart';
import 'package:tour_guide_rental/models/AppConstants.dart';
import 'package:tour_guide_rental/models/http_exception.dart';
import 'package:tour_guide_rental/providers/auth.dart';
import 'package:tour_guide_rental/providers/pemandu_orders.dart';
import 'package:tour_guide_rental/screens/pemandu_order_screen.dart';
import 'package:tour_guide_rental/widgets/pemandu_drawer.dart';

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
  String _orderIDs;
  DocumentSnapshot _data;

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

  void _accept() async {
    try {
      await Provider.of<PemanduOrders>(
        context,
        listen: false,
      ).accept(
        _orderIDs,
        _data,
      );

      _changeStatus(false);

      Navigator.of(context).pushNamed(PemanduOrderScreen.routeName);
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      print(error.toString());
      var errorMessage = 'Connection Error. Please try again later.';
      _showErrorDialog(errorMessage);
    }
  }

  void _cancel() async {
    try {
      await Provider.of<PemanduOrders>(context).cancel(
        _orderIDs,
        _data,
      );
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      print(error.toString());
      var errorMessage = 'Connection Error. Please try again later.';
      _showErrorDialog(errorMessage);
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
                      _orderIDs = snapshot['orderIDs'];
                      _data = snapshot;
                      return CustomScrollView(
                        slivers: <Widget>[
                          SliverAppBar(
                            expandedHeight: 250,
                            pinned: true,
                            automaticallyImplyLeading: false,
                            flexibleSpace: FlexibleSpaceBar(
                              centerTitle: true,
                              title: Text(snapshot['museumName']),
                              background: Hero(
                                tag: snapshot['orderIDs'],
                                child: snapshot['museumImage'] != null
                                    ? Image.network(
                                        AppConstants.urlImage +
                                            snapshot['museumImage'],
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(AppConstants.urlUserImage +
                                        '/avatar.png'),
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                SizedBox(
                                  height: 25.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 25.0, 0, 0),
                                  child: Text(
                                    'Harga : Rp. ' + snapshot['museumPrice'],
                                    style: h4,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 10.0, 0, 0),
                                  child: Text(
                                    'Wisatawan : ' + snapshot['wisatawanName'],
                                    style: h5,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 10.0, 0, 0),
                                  child: Text(
                                    'Tanggal : ' +
                                        DateFormat('dd-MM-yyyy hh:mm').format(
                                            snapshot['dateTime'].toDate()),
                                    style: h5,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0),
                                  child: froyoFlatBtn(
                                    'Terima',
                                    _accept,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0),
                                  child: froyoFlatBtnCancel(
                                    'Cancel',
                                    _cancel,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
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

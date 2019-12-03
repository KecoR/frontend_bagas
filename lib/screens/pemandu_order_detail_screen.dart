import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:tour_guide_rental/helpers/buttons.dart';
import 'package:tour_guide_rental/helpers/colors.dart';
import 'package:tour_guide_rental/helpers/styles.dart';
import 'package:tour_guide_rental/models/AppConstants.dart';
import 'package:tour_guide_rental/providers/auth.dart';
import 'package:tour_guide_rental/providers/pemandu_orders.dart';
import 'package:tour_guide_rental/screens/conversation_screen.dart';
import 'package:tour_guide_rental/screens/pemandu_order_screen.dart';

class PemanduOrderDetailScreen extends StatefulWidget {
  static const routeName = '/pemandu-order-detail';

  @override
  _PemanduOrderDetailScreenState createState() =>
      _PemanduOrderDetailScreenState();
}

class _PemanduOrderDetailScreenState extends State<PemanduOrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context).settings.arguments as String;
    final loadedOrder = Provider.of<PemanduOrders>(
      context,
      listen: false,
    ).findById(orderId);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: BackButton(
          color: white,
        ),
        title: Text(
          'Detail Order',
          style: h5,
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedOrder.museumName),
              background: Hero(
                tag: loadedOrder.id,
                child: Image.network(
                  AppConstants.urlImage + loadedOrder.museumImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 25.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    loadedOrder.status == '1'
                        ? Text(
                            'Success',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.lightGreen,
                              fontSize: 25,
                            ),
                          )
                        : (loadedOrder.status == '-1'
                            ? Text(
                                'Canceled',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 25,
                                ),
                              )
                            : Text(
                                'On-Process',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontSize: 25,
                                ),
                              ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 25.0, 0, 0),
                  child: Text(
                    'Harga : Rp. ${loadedOrder.museumPrice}',
                    style: h4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 10.0, 0, 0),
                  child: Text(
                    'Wisatawan : ${loadedOrder.wisatawanName}',
                    style: h5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 10.0, 0, 0),
                  child: Text(
                    'Tanggal : ' +
                        DateFormat('dd-MM-yyyy hh:mm')
                            .format(loadedOrder.dateTime),
                    style: h5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0),
                  child: froyoOutlineBtn('Kirim Pesan', () {
                    Navigator.of(context).pushNamed(
                      ConversationScreen.routeName,
                      arguments: loadedOrder.messageID,
                    );
                  }),
                ),
                if (loadedOrder.status != '1' && loadedOrder.status != '-1')
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0),
                    child: froyoFlatBtn('Selesai', () {
                      Provider.of<PemanduOrders>(context)
                          .finish(loadedOrder.id);

                      Navigator.pop(context);
                      Navigator.of(context)
                          .pushReplacementNamed(PemanduOrderScreen.routeName);
                    }),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
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
}

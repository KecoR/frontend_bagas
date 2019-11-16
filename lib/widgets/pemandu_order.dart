import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_rental/helpers/buttons.dart';
import 'package:tour_guide_rental/helpers/styles.dart';
import 'package:tour_guide_rental/models/AppConstants.dart';
import 'package:tour_guide_rental/models/http_exception.dart';
import 'package:tour_guide_rental/providers/pemandu_orders.dart';
import 'package:tour_guide_rental/screens/pemandu_order_screen.dart';

class PemanduOrder extends StatefulWidget {
  DocumentSnapshot data;

  PemanduOrder(this.data);

  @override
  _PemanduOrderState createState() => _PemanduOrderState();
}

class _PemanduOrderState extends State<PemanduOrder> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(widget.data['museumName']),
            background: Hero(
              tag: widget.data['orderIDs'],
              child: widget.data['museumImage'] != null
                  ? Image.network(
                      AppConstants.urlImage + widget.data['museumImage'],
                      fit: BoxFit.cover,
                    )
                  : Image.network(AppConstants.urlUserImage + '/avatar.png'),
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
                padding: const EdgeInsets.fromLTRB(25.0, 25.0, 0, 0),
                child: Text(
                  'Harga : Rp. ' + widget.data['museumPrice'],
                  style: h4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 10.0, 0, 0),
                child: Text(
                  'Wisatawan : ' + widget.data['wisatawanName'],
                  style: h5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 10.0, 0, 0),
                child: Text(
                  'Tanggal : ' +
                      DateFormat('dd-MM-yyyy hh:mm')
                          .format(widget.data['dateTime'].toDate()),
                  style: h5,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0),
                child: froyoFlatBtn(
                  'Terima',
                  _accept,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0),
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

  void _accept() async {
    try {
      await Provider.of<PemanduOrders>(
        context,
        listen: false,
      ).accept(widget.data['orderIDs'], widget.data);

      // Navigator.of(context).pushNamed(PemanduOrderScreen.routeName);
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
      await Provider.of<PemanduOrders>(context)
          .cancel(widget.data['orderIDs'], widget.data);
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      print(error.toString());
      var errorMessage = 'Connection Error. Please try again later.';
      _showErrorDialog(errorMessage);
    }
  }
}

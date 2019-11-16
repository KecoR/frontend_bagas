import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:tour_guide_rental/helpers/colors.dart';
import 'package:tour_guide_rental/helpers/styles.dart';
import 'package:tour_guide_rental/models/AppConstants.dart';
import 'package:tour_guide_rental/models/http_exception.dart';
import 'package:tour_guide_rental/providers/orders.dart';

class OrderDetailScreen extends StatefulWidget {
  static const routeName = '/order-detail';

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  double _rating = 0;
  double _ratingOld = 0;

  var _orderId;

  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context).settings.arguments as String;
    final loadedOrder = Provider.of<Orders>(
      context,
      listen: false,
    ).findById(orderId);

    if (loadedOrder.rating != null) {
      _rating = loadedOrder.rating;
      _ratingOld = loadedOrder.rating;
    }

    if (loadedOrder.status != '1') {
      _rating = 0;
      _ratingOld = 0;
    }

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
                    'Pemandu : ${loadedOrder.pemanduName}',
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
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Form(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 10.0),
                                  child: StarRating(
                                    rating: _rating,
                                    size: 40.0,
                                    starCount: 5,
                                    color: Colors.deepOrange,
                                    borderColor: Colors.grey,
                                    onRatingChanged: (rating) {
                                      setState(() {
                                        _rating = rating;
                                        _orderId = loadedOrder.id;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_ratingOld == 0 && loadedOrder.status == '1')
                            MaterialButton(
                              onPressed: _submit,
                              child: Text('Submit'),
                              color: Colors.blue,
                            ),
                        ],
                      ),
                    ),
                  ),
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

  void _submit() async {
    try {
      await Provider.of<Orders>(context).giveRating(_orderId, _rating);
      setState(() {
        _ratingOld = _rating;
      });
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      print(error.toString());
      var errorMessage = 'Connection Error. Please try again later.';
      _showErrorDialog(errorMessage);
    }
  }
}

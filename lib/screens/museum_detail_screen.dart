import 'package:flutter/material.dart';
import 'package:tour_guide_rental/helpers/buttons.dart';
import 'package:tour_guide_rental/helpers/colors.dart';
import 'package:tour_guide_rental/helpers/styles.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_rental/models/AppConstants.dart';
import 'package:tour_guide_rental/models/http_exception.dart';
import 'package:tour_guide_rental/providers/auth.dart';
// import 'package:tour_guide_rental/providers/auth.dart';
import 'package:tour_guide_rental/providers/orders.dart';
import 'package:tour_guide_rental/screens/oders_screen.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../providers/museums.dart';

class MuseumDetailScreen extends StatelessWidget {
  // final String museum_name;

  // MuseumDetailScreen(this.museum_name);

  static const routeName = '/museum-detail';

  @override
  Widget build(BuildContext context) {
    final museumId = ModalRoute.of(context).settings.arguments as String;
    final loadedMuseum = Provider.of<Museums>(
      context,
      listen: false,
    ).findById(museumId);
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

    void _orderPemandu() async {
      try {
        await Provider.of<Orders>(context).orderPemandu(museumId);

        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
      } on HttpException catch (error) {
        _showErrorDialog(error.toString());
      } catch (error) {
        print(error.toString());
        var errorMessage = 'Connection Error. Please try again later.';
        _showErrorDialog(errorMessage);
      }
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
          loadedMuseum.museumName,
          style: h5,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Center(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(top: 100, bottom: 100),
                      padding: EdgeInsets.only(top: 100, bottom: 50),
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(loadedMuseum.museumName, style: h5),
                          Text('Rp. ${loadedMuseum.museumPrice}', style: h3),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            width: double.infinity,
                            child: Text(
                              loadedMuseum.museumDesc,
                              textAlign: TextAlign.justify,
                              softWrap: true,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 180,
                            child: froyoOutlineBtn(
                              'Order Pemandu',
                              _orderPemandu,
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            spreadRadius: 5,
                            color: Color.fromRGBO(0, 0, 0, .05),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 180,
                      height: 180,
                      margin: EdgeInsets.only(left: 20),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: 180,
                            height: 180,
                            child: RaisedButton(
                              color: white,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Hero(
                                transitionOnUserGestures: true,
                                tag: loadedMuseum.museumName,
                                child: Container(
                                  height: 300,
                                  width: double.infinity,
                                  child: Image.network(
                                    AppConstants.urlImage +
                                        loadedMuseum.museumImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: (loadedMuseum.museumRating != null)
                                ? Container(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 10, right: 10, bottom: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[600],
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Text(
                                      loadedMuseum.museumRating + "/100",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                : SizedBox(width: 0),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

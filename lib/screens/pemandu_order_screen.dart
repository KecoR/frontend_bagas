import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_rental/helpers/buttons.dart';
import 'package:tour_guide_rental/models/http_exception.dart';
import 'package:tour_guide_rental/providers/pemandu_orders.dart';
import 'package:tour_guide_rental/widgets/pemandu_drawer.dart';

class PemanduOrderScreen extends StatefulWidget {
  @override
  _PemanduOrderScreenState createState() => _PemanduOrderScreenState();

  static const routeName = '/pemandu-order';
}

class _PemanduOrderScreenState extends State<PemanduOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: PemanduDrawer(),
      body: Container(),
    );
  }
}

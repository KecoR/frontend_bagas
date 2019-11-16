import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tour_guide_rental/helpers/buttons.dart';

import 'package:tour_guide_rental/providers/orders.dart' as ord;
import 'package:tour_guide_rental/screens/order_detail_screen.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              widget.order.museumName,
            ),
            leading: Container(
              width: 75.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.order.status == '1'
                      ? Text(
                          'Success',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.lightGreen,
                          ),
                        )
                      : (widget.order.status == '-1'
                          ? Text(
                              'Canceled',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            )
                          : Text(
                              'On-Process',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.lightBlue,
                              ),
                            ))
                ],
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                DateFormat('dd-MM-yyyy hh:mm').format(widget.order.dateTime),
              ),
            ), //Will Change to Pemandu Name - Date Order =>
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              height: min(widget.order.museumName.length * 20.0 + 100, 125),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, bottom: 10.0),
                    child: Text(
                      'Nama Pemandu : ' + widget.order.pemanduName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, bottom: 10.0),
                    child: Text(
                      'Harga : ' + widget.order.museumPrice,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                    ),
                    child: froyoFlatBtn('Detail Order', () {
                      Navigator.of(context).pushNamed(
                        OrderDetailScreen.routeName,
                        arguments: widget.order.id,
                      );
                    }),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}

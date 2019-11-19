import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_rental/providers/pemandu_orders.dart'
    show PemanduOrders;
import 'package:tour_guide_rental/widgets/pemandu_drawer.dart';
import 'package:tour_guide_rental/widgets/pemandu_order_item.dart';

class PemanduOrderScreen extends StatelessWidget {
  static const routeName = '/pemandu-orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: PemanduDrawer(),
      body: FutureBuilder(
        future: Provider.of<PemanduOrders>(context, listen: false)
            .fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<PemanduOrders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) =>
                      PemanduOrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}

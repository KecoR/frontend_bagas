import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_rental/providers/auth.dart';
import 'package:tour_guide_rental/screens/museums_overview_screen.dart';

import 'package:tour_guide_rental/screens/oders_screen.dart';
import 'package:tour_guide_rental/screens/pemandu_screen.dart';
import 'package:tour_guide_rental/screens/profile_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context).roleId;
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          if (auth == '3')
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Museum List'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(MuseumsOverviewScreen.routeName);
              },
            ),
          if (auth == '3') Divider(),
          if (auth == '3')
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Your Order'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              },
            ),
          if (auth == '3') Divider(),
          if (auth == '2')
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(PemanduScreen.routeName);
              },
            ),
          if (auth == '2') Divider(),
          if (auth == '2')
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Your Order'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              },
            ),
          if (auth == '2') Divider(),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Profile'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProfileScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}

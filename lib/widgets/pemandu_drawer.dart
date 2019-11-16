import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_rental/providers/auth.dart';
import 'package:tour_guide_rental/screens/oders_screen.dart';
import 'package:tour_guide_rental/screens/pemandu_order_screen.dart';
import 'package:tour_guide_rental/screens/pemandu_screen.dart';
import 'package:tour_guide_rental/screens/profile_screen.dart';

class PemanduDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(PemanduScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(PemanduOrderScreen.routeName);
            },
          ),
          Divider(),
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

import 'package:flutter/material.dart';
// import 'package:tour_guide_rental/providers/museum.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_rental/models/AppConstants.dart';
import 'package:tour_guide_rental/providers/account.dart';
import 'package:tour_guide_rental/providers/auth.dart';
import 'package:tour_guide_rental/providers/message.dart';
import 'package:tour_guide_rental/providers/orders.dart';
import 'package:tour_guide_rental/providers/pemandu_orders.dart';
import 'package:tour_guide_rental/screens/auth_screen.dart';
import 'package:tour_guide_rental/screens/conversation_screen.dart';
import 'package:tour_guide_rental/screens/edit_profile_screen.dart';
import 'package:tour_guide_rental/screens/museum_detail_screen.dart';
import 'package:tour_guide_rental/screens/museums_overview_screen.dart';
import 'package:tour_guide_rental/screens/oders_screen.dart';
import 'package:tour_guide_rental/screens/order_detail_screen.dart';
import 'package:tour_guide_rental/screens/pemandu_order_detail_screen.dart';
import 'package:tour_guide_rental/screens/pemandu_order_screen.dart';
import 'package:tour_guide_rental/screens/pemandu_screen.dart';
import 'package:tour_guide_rental/screens/profile_screen.dart';
import 'package:tour_guide_rental/screens/splash-screen.dart';
import 'package:tour_guide_rental/screens/topup_screen.dart';

import './providers/museums.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Museums>(
          builder: (ctx, auth, previousMuseums) => Museums(
            previousMuseums == null ? [] : previousMuseums.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (ctx, auth, previousOrders) => Orders(
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, UserData>(
          builder: (ctx, auth, previousUser) => UserData(
            auth.userId,
            previousUser == null ? null : previousUser.user,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, PemanduOrders>(
          builder: (ctx, auth, previousOrders) => PemanduOrders(
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Conversation>(
          builder: (ctx, auth, previousOrders) => Conversation(
            auth.userId,
            auth.fullName,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: AppConstants.appName,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            primaryColor: Colors.purple,
            fontFamily: 'Lato',
          ),
          // home: MuseumsOverviewScreen(),
          home: auth.isAuth
              ? (auth.roleId == '3' ? MuseumsOverviewScreen() : PemanduScreen())
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            PemanduScreen.routeName: (ctx) => PemanduScreen(),
            PemanduOrderScreen.routeName: (ctx) => PemanduOrderScreen(),
            MuseumsOverviewScreen.routeName: (ctx) => MuseumsOverviewScreen(),
            MuseumDetailScreen.routeName: (ctx) => MuseumDetailScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            OrderDetailScreen.routeName: (ctx) => OrderDetailScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            TopupScreen.routeName: (ctx) => TopupScreen(),
            EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
            ConversationScreen.routeName: (ctx) => ConversationScreen(),
            PemanduOrderDetailScreen.routeName: (ctx) =>
                PemanduOrderDetailScreen(),
          },
        ),
      ),
    );
  }
}

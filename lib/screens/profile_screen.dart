import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_rental/helpers/buttons.dart';
import 'package:tour_guide_rental/models/AppConstants.dart';
import 'package:tour_guide_rental/providers/account.dart';
import 'package:tour_guide_rental/providers/auth.dart';
import 'package:tour_guide_rental/screens/edit_profile_screen.dart';
import 'package:tour_guide_rental/screens/topup_screen.dart';
import 'package:tour_guide_rental/widgets/app_drawer.dart';
import 'package:tour_guide_rental/widgets/pemandu_drawer.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _isInit = true;
  var _isLoading = false;

  Future<void> _refreshUser(BuildContext context) async {
    await Provider.of<UserData>(context).fetchAndSetUser();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<UserData>(context).fetchAndSetUser().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final userData = Provider.of<UserData>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false).roleId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
      ),
      drawer: auth == '3' ? AppDrawer() : PemanduDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshUser(context),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: deviceSize.width / 9.5,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(userData.user.image !=
                                    null
                                ? AppConstants.urlUserImage +
                                    userData.user.image
                                : AppConstants.urlUserImage + '/avatar.png'),
                            radius: deviceSize.width / 10,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AutoSizeText(
                                userData.user.name != null
                                    ? userData.user.name
                                    : '-',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                maxLines: 2,
                              ),
                              AutoSizeText(
                                userData.user.email != null
                                    ? userData.user.email
                                    : '-',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          ProfileScreenListView(
                            text: userData.user.saldo != null
                                ? 'Rp. ' + userData.user.saldo
                                : 'Rp. 0',
                            iconData: Icons.monetization_on,
                          ),
                          ProfileScreenListView(
                            text: userData.user.hp != null
                                ? userData.user.hp
                                : '-',
                            iconData: Icons.phone_android,
                          ),
                          ProfileScreenListView(
                            text: userData.user.birthDate != null
                                ? userData.user.birthDate
                                : '-',
                            iconData: Icons.date_range,
                          ),
                          ProfileScreenListView(
                            text: userData.user.address != null
                                ? userData.user.address
                                : '-',
                            iconData: Icons.home,
                          ),
                          froyoFlatBtn('Edit Profile', () {
                            Navigator.pushNamed(
                              context,
                              EditProfileScreen.routeName,
                            );
                          }),
                          froyoOutlineBtn(
                            'Isi Saldo',
                            () {
                              Navigator.pushNamed(
                                context,
                                TopupScreen.routeName,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class ProfileScreenListView extends StatelessWidget {
  final String text;
  final IconData iconData;

  ProfileScreenListView({Key key, this.text, this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        this.text,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      trailing: Icon(
        this.iconData,
        size: 30.0,
      ),
    );
  }
}

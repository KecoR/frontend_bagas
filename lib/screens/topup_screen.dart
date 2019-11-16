import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_rental/helpers/colors.dart';
import 'package:tour_guide_rental/helpers/styles.dart';
import 'package:tour_guide_rental/models/http_exception.dart';
import 'package:tour_guide_rental/providers/auth.dart';

class TopupScreen extends StatelessWidget {
  static const routeName = '/topup';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
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
          'Topup Saldo',
          style: h5,
        ),
      ),
      body: Container(
        height: deviceSize.height,
        width: deviceSize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: deviceSize.width > 600 ? 2 : 1,
              child: AuthCard(),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'saldo': '',
  };

  var _isLoading = false;

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
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false)
          .isiSaldo(_authData['saldo']);
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      print(error.toString());
      var errorMessage = 'Connection Error. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: 175,
        constraints: BoxConstraints(minHeight: 175),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Top-up Saldo'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty || int.parse(value) < 1000) {
                      return 'Invalid saldo!';
                    }
                  },
                  onSaved: (value) {
                    _authData['saldo'] = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text('Submit'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

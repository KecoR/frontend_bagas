import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:tour_guide_rental/providers/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_rental/helpers/buttons.dart';
import 'package:tour_guide_rental/helpers/colors.dart';
import 'package:tour_guide_rental/helpers/styles.dart';
import 'package:tour_guide_rental/models/AppConstants.dart';
import 'package:tour_guide_rental/providers/account.dart';

class EditProfileScreen extends StatelessWidget {
  static const routeName = '/edit-profile';

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: false);
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
          'Edit Profile',
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
              child: AuthCard(userData),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  final UserData userData;

  AuthCard(this.userData);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _userData = {
    'full_name': '',
    'email': '',
    'email_old': '',
    'password': '',
    'no_hp': '',
    'alamat': '',
    'date_birth': '',
    'image': '',
  };

  TextEditingController _fullNameController;
  TextEditingController _emailController;
  TextEditingController _hpController;
  TextEditingController _addressController;

  DateTime _dateBirth;

  File _newImage;

  @override
  void initState() {
    _fullNameController = TextEditingController(
      text: this.widget.userData.user.name,
    );
    _emailController = TextEditingController(
      text: this.widget.userData.user.email,
    );
    _hpController = TextEditingController(
      text: this.widget.userData.user.hp,
    );
    _addressController = TextEditingController(
      text: this.widget.userData.user.address,
    );
    _dateBirth = DateTime.parse(this.widget.userData.user.birthDate);

    _userData['email_old'] = this.widget.userData.user.email;
    _userData['email'] = this.widget.userData.user.email;
    _userData['image'] = this.widget.userData.user.image;
    super.initState();
  }

  var _isLoading = false;

  void _showDatePicker() {
    DatePicker.showDatePicker(context,
        pickerTheme: DateTimePickerTheme(
          showTitle: true,
          confirm: Text(
            'Done',
            style: TextStyle(color: Colors.red),
          ),
          cancel: Text(
            'Cancel',
            style: TextStyle(color: Colors.cyan),
          ),
        ),
        minDateTime: DateTime.parse('1980-01-01'),
        maxDateTime: DateTime.parse('2020-01-01'),
        initialDateTime: _dateBirth,
        dateFormat: 'yyyy-MMMM-dd', onChange: (value, _) {
      setState(() {
        _userData['date_birth'] = value.toString();
      });
    }, onConfirm: (value, _) {
      setState(() {
        _userData['date_birth'] = value.toString();
      });
    });
  }

  void _chooseImage() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _newImage = imageFile;
        _userData['image'] = base64Encode(imageFile.readAsBytesSync());
      });
    }
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
      await Provider.of<Auth>(
        context,
        listen: false,
      ).editProfile(
        _userData['email'],
        _userData['email_old'],
        _userData['full_name'],
        _userData['password'],
        _userData['no_hp'],
        _userData['alamat'],
        _userData['date_birth'],
        _userData['image'],
      );
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

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: 500,
        constraints: BoxConstraints(minHeight: 500),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  enabled: false,
                  controller: _emailController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'New Password'),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  onSaved: (value) {
                    _userData['password'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Full Name'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Invalid fullname!';
                    }
                  },
                  onSaved: (value) {
                    _userData['full_name'] = value;
                  },
                  controller: _fullNameController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'No Handphone'),
                  keyboardType: TextInputType.number,
                  controller: _hpController,
                  validator: (value) {
                    if (value.length < 10) {
                      return 'Invalid no handphone';
                    }
                  },
                  onSaved: (value) {
                    _userData['no_hp'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address'),
                  keyboardType: TextInputType.text,
                  controller: _addressController,
                  maxLines: 3,
                  onSaved: (value) {
                    _userData['alamat'] = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                floatingActionButton(_showDatePicker),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: _chooseImage,
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: deviceSize.width / 4.8,
                    child: CircleAvatar(
                      backgroundImage: (_newImage != null)
                          ? FileImage(_newImage)
                          : NetworkImage(_userData['image'] != null
                              ? AppConstants.urlUserImage + _userData['image']
                              : AppConstants.urlUserImage + '/avatar.png'),
                      radius: deviceSize.width / 5,
                    ),
                  ),
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

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../helper/validator.dart';
import '../helper/api.dart';
import '../model/user_data.dart';
import '../ui_user/login.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';

  @override
  State<StatefulWidget> createState() {
    return new _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _key = new GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _validate = false;
  RegisterData _registerData = RegisterData();
  bool _obscureText = true;
  bool _obscureText1 = true;
  File _image;

  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  FocusNode _focusNode;

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = new FocusNode();
    _focusNode.addListener(_onOnFocusNodeEvent);
  }

  _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

//This will change the color of the icon based upon the focus on the field
  Color getPrefixIconColor() {
    return _focusNode.hasFocus ? Colors.black : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      body: new Center(
        child: new SingleChildScrollView(
          child: new Container(
            margin: new EdgeInsets.all(20.0),
            child: Center(
              child: new Form(
                key: _key,
                autovalidate: _validate,
                child: _getFormUI(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getFormUI() {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    return new Column(
      children: <Widget>[
        new Image.asset(
          'assets/images/logo.png',
          height: 100,
          width: 100,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.lightBlueAccent,
                child: ClipOval(
                  child: new SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: (_image != null)
                        ? Image.file(
                            _image,
                            fit: BoxFit.fill,
                          )
                        : Image.asset(
                            'assets/images/user.png',
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 60.0),
              child: IconButton(
                icon: Icon(
                  Icons.camera,
                  size: 30.0,
                ),
                onPressed: () {
                  getImage();
                },
              ),
            ),
          ],
        ),
        new SizedBox(height: 20.0),
        new TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Full Name',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
              borderSide: BorderSide(width: 1, color: Colors.lightBlueAccent),
            ),
          ),
          validator: FormValidator().validateTextInput,
          onSaved: (String value) {
            _registerData.name = value;
          },
        ),
        new SizedBox(height: 20.0),
        new TextFormField(
          keyboardType: TextInputType.numberWithOptions(),
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Mobile Number',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
              borderSide: BorderSide(width: 1, color: Colors.lightBlueAccent),
            ),
          ),
          validator: FormValidator().validatePhone,
          onSaved: (String value) {
            _registerData.phone = value;
          },
        ),
        new SizedBox(height: 20.0),
        new TextFormField(
            autofocus: false,
            controller: _pass,
            obscureText: _obscureText,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Password',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
                borderSide: BorderSide(width: 1, color: Colors.lightBlueAccent),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: this.getPrefixIconColor(),
                  semanticLabel:
                      _obscureText ? 'show password' : 'hide password',
                ),
              ),
            ),
            validator: FormValidator().validatePassword,
            onSaved: (String value) {
              _registerData.password = value;
            }),
        new SizedBox(height: 20.0),
        new TextFormField(
            autofocus: false,
            controller: _confirmPass,
            obscureText: _obscureText1,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Confirm Password',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
                borderSide: BorderSide(width: 1, color: Colors.lightBlueAccent),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText1 = !_obscureText1;
                  });
                },
                child: Icon(
                  _obscureText1 ? Icons.visibility : Icons.visibility_off,
                  color: this.getPrefixIconColor(),
                  semanticLabel:
                      _obscureText1 ? 'show password' : 'hide password',
                ),
              ),
            ),
            validator: (val) {
              if (val.isEmpty) return 'Password Confirmation Required';
              if (val != _pass.text) return 'Password does not Match';
              return null;
            }),
        new SizedBox(height: 15.0),
        new Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: _sendToServer,
            padding: EdgeInsets.all(12),
            color: Colors.lightBlueAccent,
            child: Text('Register', style: TextStyle(color: Colors.white)),
          ),
        ),
        new FlatButton(
          onPressed: _sendToLoginPage,
          child: Text('Already member? Lon In now',
              style: TextStyle(color: Theme.of(context).accentColor)),
        ),
      ],
    );
  }

  _sendToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      if (_image != null) {
        String base64Image = base64Encode(_image.readAsBytesSync());
        String fileName = _image.path.split("/").last;
        http.post(Api.baseURL+"register.php", body: {
          "profile":"true",
          "image": base64Image,
          "image_name": fileName,
          "name": _registerData.name,
          "phone": _registerData.phone,
          "pass": _registerData.password,
        }).then((res) {
          print(res.body);
          scaffoldKey.currentState.showSnackBar(SnackBar(
              content: new Text(res.body.toString()),
              duration: const Duration(milliseconds: 1500)));
        }).catchError((err) {
          print(err);
        });
      } else {
        http.post(Api.baseURL+"register.php", body: {
          "profile":"false",
          "name": _registerData.name,
          "phone": _registerData.phone,
          "pass": _registerData.password,
        }).then((res) {
          print(res.body);
          scaffoldKey.currentState.showSnackBar(SnackBar(
              content: new Text(res.body.toString()),
              duration: const Duration(milliseconds: 1500)));
        }).catchError((err) {
          print(err);
        });
      }
      print("Phone ${_registerData.phone}");
      print("Password ${_registerData.password}");
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }
}

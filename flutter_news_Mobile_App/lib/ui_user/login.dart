import 'dart:convert';
import 'dart:math';

import 'package:classic_flutter_news/helper/constants.dart';
import 'package:classic_flutter_news/ui_user/forgot.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/home_provider.dart';
import '../helper/validator.dart';
import '../model/user_data.dart';
import 'registration.dart';
import '../ui/main_activity.dart';
import '../helper/api.dart';
import '../helper/sharedPref.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _key = new GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _validate = false;
  LoginRequestData _loginData = LoginRequestData();
  RegisterData _registerData = RegisterData();
  bool _obscureText = true;
  SharedPref sharedPref = SharedPref();

  FocusNode _focusNode;

  final _text = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _text.dispose();
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
    return new Column(
      children: <Widget>[
        new Image.asset(
          'assets/images/logo.png',
          height: 100,
          width: 100,
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
            _loginData.email = value;
          },
        ),
        new SizedBox(height: 20.0),
        new TextFormField(
            autofocus: false,
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
              _loginData.password = value;
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
            child: Text('Log In', style: TextStyle(color: Colors.white)),
          ),
        ),
        new FlatButton(
          child: Text(
            'Forgot password?',
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          onPressed: _resetDialogBox,
        ),
        new FlatButton(
          onPressed: _sendToRegisterPage,
          child: Text('Not a member? Sign up now',
              style: TextStyle(color: Theme.of(context).accentColor)),
        ),
        new FlatButton(
          onPressed: _sendToHomePage,
          child: Text('Skip for now', style: TextStyle(color: Theme.of(context).accentColor)),
        ),
      ],
    );
  }

  _sendToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  _sendToHomePage() async {
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: MainActivity(),
      ),
    );
    Provider.of<HomeProvider>(context, listen: false).getFeeds();
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      http.post(Api.baseURL + "check.php", body: {
        "email": _loginData.email,
        "password": _loginData.password,
      }).then((res) {
        print(res.body.toString());
        final jsonResponse = json.decode(res.body);
        if(jsonResponse["status"]=='fail'){
          scaffoldKey.currentState.showSnackBar(SnackBar(
              content: new Text(jsonResponse["msg"]),
              duration: const Duration(milliseconds: 1500)));
        }else{
          _registerData = RegisterData.fromJson(jsonResponse);
          sharedPref.saveString("name", _registerData.name);
          sharedPref.saveString("phone", _registerData.phone);
          sharedPref.saveString("SrNo", _registerData.srNo);
          sharedPref.saveString("isLogin", "1");
          sharedPref.saveString("profile", jsonResponse["user"]["profile"]);
          _sendToHomePage();
        }
      }).catchError((err) {
        print(err);
      });
      print("Email ${_loginData.email}");
      print("Password ${_loginData.password}");
    } else {
// validation error
      setState(() {
        _validate = true;
      });
    }
  }

  // Creates an alertDialog for the user to enter their email
  Future<String> _resetDialogBox() {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomAlertDialog(title: "Reset Password");
      },
    );
  }
}

class CustomAlertDialog extends StatefulWidget {
  final String title;

  const CustomAlertDialog({Key key, this.title}) : super(key: key);

  @override
  CustomAlertDialogState createState() {
    return new CustomAlertDialogState();
  }
}

class CustomAlertDialogState extends State<CustomAlertDialog> {
  final _resetKey = GlobalKey<FormState>();
  final _resetEmailController = TextEditingController();
  String _resetEmail;
  bool _resetValidate = false;
  SharedPref sharedPref = SharedPref();

  _sendToForgotPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPage()),
    );
  }

  sendOTP(String mobile, String otp) async {
    var url = 'https://control.msg91.com/api/sendotp.php?authkey=${Constants.msg91AuthKey}&mobile=$mobile&message=Your%20Classic%20Flutter%20News%20App%20Reset%20Password%20OTP%20is%20$otp&otp=$otp';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var itemCount = jsonResponse['type'];
      print(itemCount);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  _sendResetEmail() {
    _resetEmail = _resetEmailController.text;

    if (_resetKey.currentState.validate()) {
      _resetKey.currentState.save();

      try {
        // You could consider using async/await here
        return true;
      } catch (exception) {
        print(exception);
      }
    } else {
      setState(() {
        _resetValidate = true;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: new Text(widget.title),
        content: new SingleChildScrollView(
          child: Form(
            key: _resetKey,
            autovalidate: _resetValidate,
            child: ListBody(
              children: <Widget>[
                new Text(
                  'Enter the Mobile Number associated with your account.',
                  style: TextStyle(fontSize: 14.0),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Row(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Icon(
                        Icons.phonelink_lock,
                        size: 20.0,
                      ),
                    ),
                    new Expanded(
                      child: TextFormField(
                        validator: FormValidator().validatePhone,
                        onSaved: (String val) {
                          _resetEmail = val;
                        },
                        controller: _resetEmailController,
                        keyboardType: TextInputType.phone,
                        autofocus: true,
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Mobile Number',
                            contentPadding:
                                EdgeInsets.only(left: 25.0, top: 15.0),
                            hintStyle:
                                TextStyle(color: Theme.of(context).accentColor, fontSize: 14.0)),
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    )
                  ],
                ),
                new Column(children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                        border: new Border(
                            bottom: new BorderSide(
                                width: 0.5, color: Theme.of(context).accentColor))),
                  )
                ]),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              'CANCEL',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            onPressed: () {
              Navigator.of(context).pop("");
            },
          ),
          new FlatButton(
            child: new Text(
              'RESET',
              style: TextStyle(color:Theme.of(context).accentColor),
            ),
            onPressed: () {
              if (_sendResetEmail()) {
                String otp = "";
                var rnd = new Random();
                for (var i = 0; i < 4; i++) {
                  otp = otp + rnd.nextInt(9).toString();
                }
                Navigator.of(context).pop(_resetEmail);
                sendOTP(_resetEmail,otp);
                sharedPref.saveString("resetMobile", _resetEmail);
                sharedPref.saveString("resetOTP", otp);
                _sendToForgotPage();
              }
            },
          ),
        ],
      ),
    );
  }
}

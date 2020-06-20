import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/validator.dart';
import '../model/user_data.dart';
import 'login.dart';
import 'registration.dart';
import '../helper/api.dart';
import '../helper/constants.dart';

class ForgotPage extends StatefulWidget {
  static String tag = 'forgot-page';

  @override
  State<StatefulWidget> createState() {
    return new _ForgotPageState();
  }
}

class _ForgotPageState extends State<ForgotPage> {
  GlobalKey<FormState> _key = new GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _validate = false;
  LoginRequestData _loginData = LoginRequestData();
  bool _obscureText = true;

  String mobile, otp = "";

  FocusNode _focusNode;

  var onTapRecognizer;
  StreamController<ErrorAnimationType> errorController;
  bool hasError = false;
  String currentText = "";

  loadSharedPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        mobile = prefs.get('resetMobile') ?? '';
        otp = prefs.get("resetOTP") ?? '';
        print(mobile);
        print(otp);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  sendOTP(String mobile, String otp) async {
    var url =
        'https://control.msg91.com/api/sendotp.php?authkey=${Constants.msg91AuthKey}&mobile=$mobile&message=Your%20Classic%20Flutter%20News%20App%20Reset%20Password%20OTP%20is%20$otp&otp=$otp';
    //print(url);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var itemCount = jsonResponse['type'];
      print(itemCount);
      scaffoldKey.currentState.showSnackBar(SnackBar(
          content: new Text("OTP has been sent sucessfully"),
          duration: const Duration(milliseconds: 1500)));
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    loadSharedPrefs();
    _focusNode = new FocusNode();
    _focusNode.addListener(_onOnFocusNodeEvent);
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        sendOTP(mobile, otp);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    _focusNode.dispose();
    super.dispose();
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Reset Password',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
          child: RichText(
            text: TextSpan(
                text: "Enter the code sent to ",
                children: [
                  TextSpan(
                      text: mobile,
                      style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ],
                style: TextStyle(color: Colors.lightBlueAccent, fontSize: 15)),
            textAlign: TextAlign.center,
          ),
        ),
        new SizedBox(height: 20.0),
        PinCodeTextField(
          length: 4,
          obsecureText: false,
          animationType: AnimationType.fade,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            selectedFillColor: Colors.white,
            activeFillColor: Colors.white,
            inactiveFillColor: Colors.white,
          ),
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: Theme.of(context).backgroundColor,
          //enableActiveFill: true,
          errorAnimationController: errorController,
          //controller: textEditingController,
          onCompleted: (v) {
            print("Completed");
          },
          onChanged: (value) {
            print(value);
            setState(() {
              currentText = value;
            });
          },
          beforeTextPaste: (text) {
            print("Allowing to paste $text");
            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
            //but you can show anything you want here, like your pop up saying wrong paste format or etc
            return true;
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            hasError ? "*Please fill OTP correctly" : "",
            style: TextStyle(color: Colors.red.shade300, fontSize: 15),
          ),
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
        SizedBox(
          height: 20,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: "Didn't receive the code? ",
              style: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
              children: [
                TextSpan(
                    text: " RESEND",
                    recognizer: onTapRecognizer,
                    style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16))
              ]),
        ),
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
            child: Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ),
        new FlatButton(
          onPressed: _sendToLoginPage,
          child: Text('Already member? Lon In now',
              style: TextStyle(color: Theme.of(context).accentColor)),
        ),
        new FlatButton(
          onPressed: _sendToRegisterPage,
          child: Text('Not a member? Sign up now',
              style: TextStyle(color: Theme.of(context).accentColor)),
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

  _sendToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  _sendToServer() {
    if (currentText.length != 4 || currentText != otp) {
      errorController
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() {
        hasError = true;
      });
    } else if (_key.currentState.validate()) {
      // conditions for validating
      // No any error in validation
      _key.currentState.save();
      http.post(Api.baseURL + "reset.php", body: {
        "email": mobile,
        "password": _loginData.password,
      }).then((res) {
        print(res.body.toString());
        final jsonResponse = json.decode(res.body);
        scaffoldKey.currentState.showSnackBar(SnackBar(
            content: new Text(jsonResponse["msg"]),
            duration: const Duration(milliseconds: 1500)));
      }).catchError((err) {
        print(err);
      });
      print("mobile $mobile");
      print("Password ${_loginData.password}");
    } else {
      // validation error
      setState(() {
        _validate = true;
        hasError = false;
      });
    }
  }
}

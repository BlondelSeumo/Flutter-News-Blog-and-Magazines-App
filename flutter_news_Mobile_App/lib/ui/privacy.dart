import 'package:classic_flutter_news/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class Privacy extends StatefulWidget {
  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15.0,
                    ),
                    Image(
                      image: AssetImage(
                        "assets/images/logo.png",
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Html(
                      data: "${Constants.appPrivacy}",
                      backgroundColor: Theme.of(context).backgroundColor,
                      linkStyle: const TextStyle(
                        color: Colors.redAccent,
                      ),
                      onLinkTap: (url) {
                      },
                      onImageTap: (src) {
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SafeArea(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Theme.of(context).accentColor, width: 1),
                              ),
                              child: Text(
                                'Thanks...!',)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

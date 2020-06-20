import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'main_activity.dart';
import '../providers/home_provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState ();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {

  nextPage() async {
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: MainActivity(),
      ),
    );
    Provider.of<HomeProvider>(context, listen: false).getFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Stack(fit: StackFit.expand, children: <Widget>[
          Container(
            padding: EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Staying current is key in our fast-paced world.',
                  style: TextStyle(fontSize: 20.0,),
                ),
                SizedBox(height: 15),
                Text(
                  '- Classic Flutter News',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50),
                Center(
                  child: Image.asset("assets/images/ic_splash.png",
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SafeArea(
              child: InkWell(
                onTap: () {
                  nextPage();
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: EdgeInsets.only(right: 40, bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).accentColor, width: 1),
                    ),
                    child: Text(
                      'Start Reading...!',)
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

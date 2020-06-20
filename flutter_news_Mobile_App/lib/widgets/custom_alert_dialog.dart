import 'dart:ui';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAlertDialog extends StatelessWidget{

  final Widget child;

  CustomAlertDialog({
    Key key,
    @required this.child
  }) : super(key: key);

  double deviceScreenWidth;
  double deviceScreenHeight;
  double dialogBoxHeight;

  @override
  Widget build(BuildContext context) {

    Orientation orientation = MediaQuery.of(context).orientation;
    Size screenSize = MediaQuery.of(context).size;

     deviceScreenWidth = orientation == Orientation.portrait
        ? screenSize.width
        : screenSize.height;
     deviceScreenHeight = orientation == Orientation.portrait
        ? screenSize.height
        : screenSize.width;
     dialogBoxHeight = deviceScreenHeight * (0.50);

    return MediaQuery(
      data: MediaQueryData(),
      child: GestureDetector(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 0.5,
            sigmaY: 0.5,
          ),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: deviceScreenWidth*0.9,
                          child: GestureDetector(
                            onTap: (){},
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                              ),
                              child: child,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
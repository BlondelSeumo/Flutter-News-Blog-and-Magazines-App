import 'package:flutter/material.dart';

class Constants {
  static String appName = "Classic Flutter News";
  static String appPackage = "com.sachi.classic_flutter_news";

  //OTP Setup
  static String msg91AuthKey="264945AeCxvjPPygN5c756de7";

  static String appAbout =
      "<h3>Staying current is key in our fast-paced world.</h3>"
      "Most people wouldn’t even consider getting a physical morning newspaper anymore, "
      "so we depend on digital sources for our news. Finding an app that helps you get the news you want in a timely manner is essential."
      "<p>Now all are in your handy. The app contains so many popular categories of news. Such as news, business, magazines, sports, jobs, technology and entertainment. You can read, bookmark, and share the news with others.</p>"
      '<p>Now all are in your handy. The app contains so many popular categories of news. Such as news, business, magazines, sports, jobs, technology and entertainment. You can read, bookmark, and share the news with others.</p>'
      "<p>Now all are in your handy. The app contains so many popular categories of news. Such as news, business, magazines, sports, jobs, technology and entertainment. You can read, bookmark, and share the news with others.</p>"
      "<p>Now all are in your handy. The app contains so many popular categories of news. Such as news, business, magazines, sports, jobs, technology and entertainment. You can read, bookmark, and share the news with others.</p>";

  static String appPrivacy = "<h3>Privacy Policy</h3>"
      "Most people wouldn’t even consider getting a physical morning newspaper anymore, "
      "so we depend on digital sources for our news. Finding an app that helps you get the news you want in a timely manner is essential."
      "<p>Now all are in your handy. The app contains so many popular categories of news. Such as news, business, magazines, sports, jobs, technology and entertainment. You can read, bookmark, and share the news with others.</p>"
      '<p>Now all are in your handy. The app contains so many popular categories of news. Such as news, business, magazines, sports, jobs, technology and entertainment. You can read, bookmark, and share the news with others.</p>'
      "<p>Now all are in your handy. The app contains so many popular categories of news. Such as news, business, magazines, sports, jobs, technology and entertainment. You can read, bookmark, and share the news with others.</p>"
      "<p>Now all are in your handy. The app contains so many popular categories of news. Such as news, business, magazines, sports, jobs, technology and entertainment. You can read, bookmark, and share the news with others.</p>";

  static Color lightPrimary = Colors.white;
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Color(0xff06d6a7);
  static Color darkAccent = Color(0xff06d6a7);
  static Color lightBG = Color(0xFFFAFAFA);
  static Color darkBG = Color(0xFF2C2C2C);

  static ThemeData lightTheme = ThemeData(
    fontFamily: "Poppins",
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(
          fontFamily: "Poppins",
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: "Poppins",
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(
          fontFamily: "Poppins",
          color: lightBG,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );

  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }
}

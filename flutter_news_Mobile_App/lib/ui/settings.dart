import 'package:cached_network_image/cached_network_image.dart';
import 'package:classic_flutter_news/helper/api.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/app_provider.dart';
import '../providers/favorites_provider.dart';
import '../helper/constants.dart';
import '../helper/sharedPref.dart';
import 'favorites.dart';
import '../ui/about.dart';
import '../ui/privacy.dart';
import '../ui_user/login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPref sharedPref = SharedPref();
  static String isLogin;
  String _name;
  static String _profile;

  _ProfileState() {
    loadSharedPrefs();
  }

  loadSharedPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        isLogin = prefs.getString("isLogin") == null
            ? "0"
            : prefs.getString("isLogin");
        _name = prefs.getString("name") == null
            ? "Please LogIn"
            : prefs.getString("name");
        _profile = prefs.getString("profile") == null
            ? null
            : prefs.getString("profile");
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _sendToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  List items = [
    {
      "icon": Icons.favorite,
      "title": "Favorites",
      "page": Favorites(),
    },
    {"icon": Icons.brightness_6, "title": "Dark Mode"},
    {
      "icon": Icons.info,
      "title": "About",
      "page": About(),
    },
    {
      "icon": Icons.priority_high,
      "title": "Privacy Policy",
      "page": Privacy(),
    },
    {
      "icon": Icons.exit_to_app,
      "title": "Logout",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Settings",
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: new Stack(fit: StackFit.loose, children: <Widget>[
              new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: 140.0,
                    height: 140.0,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:_profile == null ? "" : Api.baseURL + _profile ,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/user.png",
                          fit: BoxFit.cover,
                          height: 140.0,
                          width: 140.0,
                        ),
                        fit: BoxFit.cover,
                        height: 140.0,
                        width: 140.0,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(top: 90.0, right: 100.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 25.0,
                        child: new Icon(
                          isLogin == "1" ? Icons.settings : Icons.lock_outline,
                          color: Colors.white,
                        ),
                      )
                    ],
                  )),
            ]),
          ),
          Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Text(
                        'Hi! $_name',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              )),
          ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              if (items[index]['title'] == "Dark Mode") {
                return SwitchListTile(
                  secondary: Icon(
                    items[index]['icon'],
                  ),
                  title: Text(
                    items[index]['title'],
                  ),
                  value: Provider.of<AppProvider>(context).theme ==
                          Constants.lightTheme
                      ? false
                      : true,
                  onChanged: (v) {
                    if (v) {
                      Provider.of<AppProvider>(context, listen: false)
                          .setTheme(Constants.darkTheme, "dark");
                    } else {
                      Provider.of<AppProvider>(context, listen: false)
                          .setTheme(Constants.lightTheme, "light");
                    }
                  },
                );
              }
              if (items[index]['title'] == "Logout" ||
                  items[index]['title'] == "LogIn") {
                items[index]['title'] = isLogin == "0" ? "LogIn" : "Logout";
              }
              return ListTile(
                onTap: () {
                  if (items[index]['title'] == "info") {
                  } else if (items[index]['title'] == "Logout") {
                    sharedPref.remove("SrNo");
                    sharedPref.remove("isLogin");
                    sharedPref.remove("name");
                    sharedPref.remove("phone");
                    sharedPref.remove("profile");
                    loadSharedPrefs();
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: new Text("You have securely logged out!"),
                        duration: const Duration(milliseconds: 500)));
                  } else if (items[index]['title'] == "LogIn") {
                    _sendToLoginPage();
                  } else {
                    Provider.of<FavoritesProvider>(context, listen: false)
                        .getFeed();
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: items[index]['page'],
                      ),
                    );
                  }
                },
                leading: Icon(
                  items[index]['icon'],
                ),
                title: Text(
                  items[index]['title'],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
          ),
        ],
      ),
    );
  }
}

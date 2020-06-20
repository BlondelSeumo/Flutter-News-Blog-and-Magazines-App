import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../db/favorite_helper.dart';
import '../podo/category.dart';
import '../helper/api.dart';

class DetailsProvider extends ChangeNotifier {
  String message;
  CategoryFeed related = CategoryFeed();
  bool loading = true;
  Entry entry;
  var favDB = FavoriteDB();

  bool faved = false;

  static var httpClient = HttpClient();

  getFeed(String url) async {
    setLoading(true);
    checkFav();
    Api.updateCount(Api.baseURL + "api_count.php?get=update&id=" + entry.id)
        .then((wow) {})
        .catchError((e) {
      throw (e);
    });
    Api.getNews(url).then((feed) {
      setRelated(feed);
      setLoading(false);
    }).catchError((e) {
      throw (e);
    });
  }

  checkFav() async {
    List c = await favDB.check({"id": entry.id});
    if (c.isNotEmpty) {
      setFaved(true);
    } else {
      setFaved(false);
    }
  }

  addFav() async {
    await favDB.add({"id": entry.id, "item": entry.toJson()});
    checkFav();
  }

  removeFav() async {
    favDB.remove({"id": entry.id}).then((v) {
      print(v);
      checkFav();
    });
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  bool isLoading() {
    return loading;
  }

  void setMessage(value) {
    message = value;
    Fluttertoast.showToast(
      msg: value,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );
    notifyListeners();
  }

  String getMessage() {
    return message;
  }

  void setRelated(value) {
    related = value;
    notifyListeners();
  }

  CategoryFeed getRelated() {
    return related;
  }

  void setEntry(value) {
    entry = value;
    notifyListeners();
  }

  void setFaved(value) {
    faved = value;
    notifyListeners();
  }
}

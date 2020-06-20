import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../podo/category.dart';
import '../helper/api.dart';

class HomeProvider with ChangeNotifier {
  String message;
  CategoryFeed top = CategoryFeed();
  CategoryFeed trends = CategoryFeed();
  CategoryFeed recent = CategoryFeed();
  bool loading = true;

  getFeeds() async {
    setLoading(true);
    Api.getNews(Api.popular).then((popular) {
      setTop(popular);
      Api.getNews(Api.breaking).then((newReleases) {
        setRecent(newReleases);
      }).catchError((e) {
        throw (e);
      });
      Api.getNews(Api.trends).then((trend) {
        setTrends(trend);
        setLoading(false);
      }).catchError((e) {
        throw (e);
      });
    }).catchError((e) {
      throw (e);
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

  void setTop(value) {
    top = value;
    notifyListeners();
  }

  CategoryFeed getTop() {
    return top;
  }

  void setRecent(value) {
    recent = value;
    notifyListeners();
  }

  CategoryFeed getRecent() {
    return recent;
  }

  void setTrends(value) {
    trends = value;
    notifyListeners();
  }

  CategoryFeed getTrends() {
    return trends;
  }
}

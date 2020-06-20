import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../db/favorite_helper.dart';

class FavoritesProvider extends ChangeNotifier {
  String message;
  List posts = List();
  bool loading = true;
  var db = FavoriteDB();

  getFeed() async {
    setLoading(true);
    posts.clear();
    db.listAll().then((all) {
      posts.addAll(all);
      setLoading(false);
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

  void setPosts(value) {
    posts = value;
    notifyListeners();
  }

  List getPosts() {
    return posts;
  }
}

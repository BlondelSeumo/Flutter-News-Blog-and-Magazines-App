import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../podo/category.dart';
import '../providers/home_provider.dart';
import '../helper/constants.dart';
import '../helper/api.dart';
import '../ui/genre.dart';

import '../widgets/book_list_item.dart';
import '../widgets/book_card.dart';
import '../widgets/spotlight.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (BuildContext context, HomeProvider homeProvider, Widget child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "${Constants.appName}",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          body: homeProvider.loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => homeProvider.getFeeds(),
                  child: ListView(
                    children: <Widget>[
                      getSearchBarUI(context),
                      Container(
                        height: 250,
                        child: Center(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            scrollDirection: Axis.horizontal,
                            itemCount: homeProvider.top.feed.entry.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              Entry entry = homeProvider.top.feed.entry[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                child: BookCard(
                                  img: entry.coverImage,
                                  entry: entry,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            stops: [0.015, 0.015],
                            colors: [
                              Color.fromRGBO(209, 2, 99, 1),
                              Theme.of(context).backgroundColor
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Categories",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 60,
                        child: Center(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            scrollDirection: Axis.horizontal,
                            itemCount: homeProvider.top.feed.link.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              Link link = homeProvider.top.feed.link[index];

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: Genre(
                                            title: "${link.title}",
                                            url: link.href,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "${link.title}",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Trending!",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            stops: [0.015, 0.015],
                            colors: [
                              Color.fromRGBO(209, 2, 99, 1),
                              Theme.of(context).backgroundColor
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GridView.builder(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                        shrinkWrap: true,
                        physics: new NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          Entry entry = homeProvider.trends.feed.entry[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: SpotLight(
                              img: entry.coverImage,
                              title: entry.title,
                              entry: entry,
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            stops: [0.015, 0.015],
                            colors: [
                              Color.fromRGBO(209, 2, 99, 1),
                              Theme.of(context).backgroundColor
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Breaking News",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: homeProvider.recent.feed.entry.length,
                        itemBuilder: (BuildContext context, int index) {
                          Entry entry = homeProvider.recent.feed.entry[index];

                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: BookListItem(
                              img: entry.coverImage,
                              title: entry.title,
                              author: entry.category[0],
                              desc: entry.summary
                                  .replaceAll(RegExp(r"<[^>]*>"), ''),
                              entry: entry,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget getSearchBarUI(BuildContext context) {
    // Create a text controller and use it to retrieve the current value
    // of the TextField.
    final _txtSearch  = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 3, bottom: 3),
                  child: TextField(
                    controller: _txtSearch,
                    onChanged: (String txt) {},
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search News...',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _txtSearch.text.isEmpty ? Fluttertoast.showToast(
                    msg: "You just perform an empty search so we had nothing to show you.",
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 5,
                  )
                      : Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: Genre(
                        title: "Search Result",
                        url: Api.searchUrl+_txtSearch.text,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.search,
                      size: 25,
                      color: Theme.of(context).backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

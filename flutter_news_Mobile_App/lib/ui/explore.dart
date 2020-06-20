import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../podo/category.dart';
import '../providers/home_provider.dart';
import '../ui/genre.dart';

class Explore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (BuildContext context, HomeProvider homeProvider, Widget child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Explore",
            ),
          ),
          body: homeProvider.loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: homeProvider.top.feed.link.length,
                  itemBuilder: (BuildContext context, int index) {
                    Link link = homeProvider.top.feed.link[index];

                    return Padding(
                      padding: EdgeInsets.only(
                          left: 15, right: 15, bottom: 0, top: 15),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: <Widget>[
                              GestureDetector(
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                    "${link.img}",
                                    height: 120.0,
                                    width: MediaQuery.of(context).size.width,
                                    placeholder: (context, url) => Container(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.close),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 10, bottom: 10, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "${link.title}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    Text(
                                      "${link.count} articles",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

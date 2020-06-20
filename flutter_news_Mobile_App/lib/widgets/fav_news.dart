import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../podo/category.dart';
import '../providers/details_provider.dart';
import '../providers/favorites_provider.dart';
import '../ui/details.dart';

class FavoriteNews extends StatelessWidget {
  final String img;
  final String title;
  final Entry entry;

  FavoriteNews({
    Key key,
    @required this.img,
    @required this.title,
    @required this.entry,
  }) : super(key: key);

  static final uuid = Uuid();
  final String imgTag = uuid.v4();
  final String titleTag = uuid.v4();
  final String authorTag = uuid.v4();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<DetailsProvider>(context, listen: false).setEntry(entry);
        Provider.of<DetailsProvider>(context, listen: false)
            .getFeed(entry.related);
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: Details(
              entry: entry,
              imgTag: imgTag,
              titleTag: titleTag,
              authorTag: authorTag,
            ),
          ),
        ).then((v) {
          Provider.of<FavoritesProvider>(context, listen: false).getFeed();
        });
      },
      child: Container(
        width: 175.0,
        height: 280.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                height: 175.0,
                width: 280.0,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        child: Hero(
                          tag: imgTag,
                          child: CachedNetworkImage(
                            imageUrl: "$img",
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/place.png",
                              fit: BoxFit.cover,
                              height: 175.0,
                              width: 175.0,
                            ),
                            fit: BoxFit.cover,
                            height: 175.0,
                            width: 175.0,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10.0,
                      right: 10.0,
                      child: SizedBox(
                        width: 30.0,
                        height: 30.0,
                        child: RawMaterialButton(
                        onPressed: () async{
                        },
                          child: !true
                              ? Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                  size: 20.0,
                                )
                              : Icon(
                                  Icons.favorite,
                                  color: Color(0xfff05042),
                                  size: 20.0,
                                ),
                          shape: new CircleBorder(
                              side: BorderSide(
                                  width: 1.0,
                                  color: Colors.white.withOpacity(0.3))),
                          elevation: 0.0,
                          fillColor: Colors.white.withOpacity(0.3),
                          padding: const EdgeInsets.all(0.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
              child: Text(
                "${title.replaceAll(r"\", "")}",
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

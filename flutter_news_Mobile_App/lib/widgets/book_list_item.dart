import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../podo/category.dart';
import '../providers/details_provider.dart';
import '../ui/details.dart';

class BookListItem extends StatelessWidget {
  final String img;
  final String title;
  final String author;
  final String desc;
  final Entry entry;

  BookListItem({
    Key key,
    @required this.img,
    @required this.title,
    @required this.author,
    @required this.desc,
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
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              elevation: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                child: Hero(
                  tag: imgTag,
                  child: CachedNetworkImage(
                    imageUrl: "$img",
                    placeholder: (context, url) => Container(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/place.png",
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: titleTag,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        "${title.replaceAll(r"\", "")}",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "${desc.replaceAll(r"\n", "\n").replaceAll(r"\r", "").replaceAll(r"\'", "'")}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.headline6.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).accentColor,
                        ),
                        child: Text(
                          '$author',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.date_range,
                          color: Theme.of(context).accentColor,
                          size: 12.0,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text("${entry.published}",
                            style: TextStyle(
                              fontSize: 10,
                            )),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

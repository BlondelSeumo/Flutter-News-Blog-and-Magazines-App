import 'package:classic_flutter_news/helper/api.dart';

class CategoryFeed {
  String version;
  String encoding;
  Feed feed;

  CategoryFeed({this.version, this.encoding, this.feed});

  CategoryFeed.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    encoding = json['encoding'];
    feed = json['feed'] != null ? new Feed.fromJson(json['feed']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['encoding'] = this.encoding;
    if (this.feed != null) {
      data['feed'] = this.feed.toJson();
    }
    return data;
  }
}

class Feed {
  List<Link> link;
  List<Entry> entry;

  Feed({this.link, this.entry});

  Feed.fromJson(Map<String, dynamic> json) {
    if (json['link'] != null) {
      link = new List<Link>();
      json['link'].forEach((v) {
        link.add(new Link.fromJson(v));
      });
    }

    if (json['entry'] != null) {
      String t = json['entry'].runtimeType.toString();
      if (t == "List<dynamic>" || t == "_GrowableList<dynamic>") {
        entry = new List<Entry>();
        json['entry'].forEach((v) {
          entry.add(new Entry.fromJson(v));
        });
      } else {
        entry = new List<Entry>();
        entry.add(new Entry.fromJson(json['entry']));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.link != null) {
      data['link'] = this.link.map((v) => v.toJson()).toList();
    }

    if (this.entry != null) {
      data['entry'] = this.entry.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Link {
  String img;
  String href;
  String title;
  String count;

  Link({this.img, this.href, this.title, this.count});

  Link.fromJson(Map<String, dynamic> json) {
    img = Api.imageURL + json['image'];
    href = json['href'];
    title = json['title'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    data['href'] = this.href;
    data['title'] = this.title;
    data['count'] = this.count;
    return data;
  }
}

class Entry {
  String id;
  String title;
  String coverImage;
  String related;
  String published;
  String newsViews;
  String summary;
  List<String> category;

  Entry({
    this.id,
    this.title,
    this.coverImage,
    this.related,
    this.published,
    this.newsViews,
    this.summary,
    this.category,
  });

  Entry.fromJson(Map<String, dynamic> json) {
    title = json['title'] != null ? json['title'] : null;
    coverImage = json['coverImage'];
    id = json['id'];
    published = json['published'] != null ? json['published'] : null;
    newsViews = json['newsViews'] != null ? json['newsViews'] : null;
    related = json['related'] != null ? json['related'] : null;
    summary = json['summary'] != null ? json['summary'] : null;

    if (json['category'] != null) {
      String t = json['category'].runtimeType.toString();
      if (t == "List<dynamic>" || t == "_GrowableList<dynamic>") {
        category = new List<String>();
        json['category'].forEach((v) {
          category.add(v);
        });
      } else {
        String cat = json['category'];
        category = cat.split(",").cast<String>();
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.title != null) {
      data['title'] = this.title;
    }
    if (this.coverImage != null) {
      data['coverImage'] = this.coverImage;
    }
    if (this.id != null) {
      data['id'] = this.id;
    }
    if (this.published != null) {
      data['published'] = this.published;
    }
    if (this.newsViews != null) {
      data['newsViews'] = this.newsViews;
    }
    if (this.related != null) {
      data['related'] = this.related;
    }

    if (this.summary != null) {
      data['summary'] = this.summary;
    }
    if (this.category != null) {
      data['category'] = this.category.map((v) => v).toList();
    }
    return data;
  }
}

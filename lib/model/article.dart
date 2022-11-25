import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/constants.dart';
import 'package:app/model/tags.dart';
import 'package:app/services/util.dart';

class Article {
  final String _imgUrl;
  final String _id;
  final String _title;
  final String _date;
  final String _article;
  final String _category;
  final List<TagInfo> tagInfo;
  const Article({id, title, date, imageUrl, article, tagInfo, category})
      : this._title = title,
        this._date = date,
        this._imgUrl = imageUrl,
        this._article = article,
        this.tagInfo = tagInfo,
        this._id = id,
        this._category = category;
  Article.constructor(id, title, date, imageUrl, article, tagInfo, category)
      : this._title = title,
        this._date = date,
        this._imgUrl = imageUrl,
        this._article = article,
        this.tagInfo = tagInfo,
        this._id = id,
        this._category = category;
  String get imageUrl => _imgUrl;
  String get title => _title;
  String get date => _date;
  String get articleUrl => _article;
  String get category => _category;
  String get id => _id;
}

class ProceduralArticle extends Article {
  ProceduralArticle({id, title, date, imageUrl, article, tagInfo})
      : super(
          id: id,
          title: title,
          date: date,
          imageUrl: imageUrl,
          article: article,
          tagInfo: tagInfo,
          category: "procedural",
        );
  factory ProceduralArticle.fromDoc(QueryDocumentSnapshot doc, String lang) {
    List<TagInfo> tags = Util.createTags(doc.data()['tags'], lang);
    return ProceduralArticle(
      title: Util.getMap(doc.data()["title"], lang),
      article: Util.getMap(doc.data()["article"], lang),
      date: Util.check(doc.data()['date'], ""),
      id: Util.check(doc.id, ""),
      imageUrl: Util.check(doc.data()['imgUrl'], Const.imgBroken),
      tagInfo: tags,
    );
  }
}

class RecommendationArticle extends Article {
  RecommendationArticle({id, title, date, imageUrl, article, tagInfo})
      : super(
          id: id,
          title: title,
          date: date,
          imageUrl: imageUrl,
          article: article,
          tagInfo: tagInfo,
          category: "recommendation",
        );
  factory RecommendationArticle.fromDoc(
      QueryDocumentSnapshot doc, String lang) {
    List<TagInfo> tags = Util.createTags(doc.data()['tags'], lang);
    return RecommendationArticle(
      title: Util.getMap(doc.data()["title"], lang),
      article: Util.getMap(doc.data()["article"], lang),
      date: Util.check(doc.data()['date'], ""),
      id: Util.check(doc.id, ""),
      imageUrl: Util.check(doc.data()['imgUrl'], Const.imgBroken),
      tagInfo: tags,
    );
  }
}

class ArchivedArticle extends Article {
  ArchivedArticle({id, title, date, imageUrl, article, tagInfo, category})
      : super(
          id: id,
          title: title,
          date: date,
          imageUrl: imageUrl,
          article: article,
          tagInfo: tagInfo,
          category: category,
        );
  factory ArchivedArticle.fromDoc(QueryDocumentSnapshot doc, String lang) {
    List<TagInfo> tags = Util.createTags(doc.data()['tags'], lang);
    return ArchivedArticle(
      title: Util.getMap(doc.data()["title"], lang),
      article: Util.getMap(doc.data()["article"], lang),
      date: Util.check(doc.data()['date'], ""),
      id: Util.check(doc.id, ""),
      imageUrl: Util.check(doc.data()['imgUrl'], Const.imgBroken),
      tagInfo: tags,
    );
  }
}

class SearchArticle extends Article {
  SearchArticle({id, title, date, imageUrl, article, tagInfo, category})
      : super(
          id: id,
          title: title,
          date: date,
          imageUrl: imageUrl,
          article: article,
          tagInfo: tagInfo,
          category: category,
        );
  factory SearchArticle.fromDoc(QueryDocumentSnapshot doc, String lang) {
    List<TagInfo> tags = Util.createTags(doc.data()['tags'], lang);
    return SearchArticle(
      title: Util.check(doc.data()['title'][lang], "-فارغة-"),
      article: Util.check(doc.data()["article"][lang], "-فارغة-"),
      date: Util.check(doc.data()['date'], ""),
      id: Util.check(doc.id, ""),
      imageUrl: Util.check(doc.data()['imgUrl'], Const.imgBroken),
      tagInfo: tags,
    );
  }
}

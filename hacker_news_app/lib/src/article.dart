import 'dart:convert' as json;
import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'serializers.dart';

part 'article.g.dart';

//see https://charafau.github.io/json2builtvalue/
//flutter packages pub run build_runner build

abstract class Article implements Built<Article, ArticleBuilder> {
  static Serializer<Article> get serializer => _$articleSerializer;

  int get id; //The item's unique id.

  @nullable
  bool get deleted;  //true if the item is deleted.

  ///This is the type of the article
  ///
  ///The type of item. One of "job", "story", "comment", "poll", or "pollopt".
  String get type;
  String get by; //	The username of the item's author.
  int get time; // 	Creation date of the item, in Unix Time.

  @nullable
  String get text; // 	The comment, story or poll text. HTML.
  @nullable
  bool get dead; // 	true if the item is dead.
  @nullable
  int get parent; // 	The comment's parent: either another comment or the relevant story.
  @nullable
  int get poll; // 	The pollopt's associated poll.
  BuiltList<int> get kids; // 	The ids of the item's comments, in ranked display order.
  @nullable
  String get url; // 	The URL of the story.
  @nullable
  int get score; // 	The story's score, or the votes for a pollopt.
  String get title; // 	The title of the story, poll or job. HTML.
  BuiltList<int> get parts; // 	A list of related pollopts, in display order.
  @nullable
  int get descendants; // 	In the case of stories or polls, the total comment count.

  Article._();
  factory Article([void Function(ArticleBuilder) updates]) = _$Article;
}

//see https://github.com/google/built_value.dart
//flutter packages pub run build_runner build
//flutter packages pub run build_runner watch

List<int> parseTopStories(String jsonString) {
  final parsed = json.jsonDecode(jsonString);
  final listOfIds = List<int>.from(parsed);
  return listOfIds;
}

Article parseArticle(String jsonString) {
  final parsed = json.jsonDecode(jsonString);
  Article article = standardSerializers.deserializeWith(Article.serializer, parsed);
  return article;
}

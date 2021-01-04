import 'dart:async';
import 'dart:collection';
import 'article.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

enum StoriesType { topStories, newStories }

class HackerNewsBloc {
  Map<int, Article> _cachedArticles;

  final _topArticlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();
  final _newArticlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  Stream<List<Article>> get topArticles => _topArticlesSubject.stream;
  Stream<List<Article>> get newArticles => _newArticlesSubject.stream;

  var _articles = <Article>[];

  Sink<StoriesType> get storiesType => _storiesTypeController.sink;

  final _storiesTypeController = StreamController<StoriesType>();

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  final _isLoadingSubject = BehaviorSubject<bool>();

  HackerNewsBloc() : _cachedArticles = new Map<int, Article>() {
    _initializeArticles();

    _storiesTypeController.stream.listen((storiesType) async {
      _getArticlesAndUpdate(_newArticlesSubject, await _getIds(StoriesType.newStories));
      _getArticlesAndUpdate(_topArticlesSubject, await _getIds(StoriesType.topStories));
    });

  }

  Future<void> _initializeArticles() async {
    _getArticlesAndUpdate(_newArticlesSubject, await _getIds(StoriesType.newStories));
    _getArticlesAndUpdate(_topArticlesSubject, await _getIds(StoriesType.topStories));
  }

  Future<List<int>> _getIds(StoriesType type) async {
    final partUrl = type == StoriesType.topStories ? 'top' : 'new';
    final url = "$_baseUrl${partUrl}stories.json";
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw HackerNewsApiError("Stories $type couldn't be fetched");
    }
    return parseTopStories(response.body).take(type == StoriesType.topStories ? 10 : 5).toList();
  }

  static const _baseUrl = 'https://hacker-news.firebaseio.com/v0/';

  _getArticlesAndUpdate(BehaviorSubject<UnmodifiableListView<Article>> subject, List<int> ids) async {
    _isLoadingSubject.add(true);
    await _updateArticles(ids).then((_) {
      subject.add(UnmodifiableListView(_articles));
      _isLoadingSubject.add(false);
    });
  }

  Future<void> _updateArticles(List<int> articleIds) async {
    final futureArticles = articleIds.map((e) => _getArticle(e));
    final all = await Future.wait(futureArticles);
    _articles = all.where((element) => element.title != null).toList();
  }

  Future<Article> _getArticle(int id) async {
    if (!_cachedArticles.containsKey(id)) {
      final itemResponse = await http.get('${_baseUrl}item/${id}.json');
      if (itemResponse.statusCode == 200) {
        _cachedArticles[id] = parseArticle(itemResponse.body);
      } else {
        throw HackerNewsApiError("Article $id couldn't be fetched");
      }
    }
    return _cachedArticles[id];
  }

  dispose() {
    _storiesTypeController.close();
    _topArticlesSubject.close();
    _newArticlesSubject.close();
  }
}

class HackerNewsApiError extends Error {
  final String message;

  HackerNewsApiError(this.message);
}

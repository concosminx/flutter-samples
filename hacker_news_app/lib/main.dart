import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hackernewsapp/src/prefs_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'src/article.dart';
import 'src/hn_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'src/widgets/headline.dart';
import 'src/widgets/search.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final hnBloc = HackerNewsBloc();
  final prefsBloc = PrefsBloc();
  runApp(MyApp(hackerNewsBloc: hnBloc, prefsBloc: prefsBloc));
}

class MyApp extends StatelessWidget {
  final HackerNewsBloc hackerNewsBloc;
  final PrefsBloc prefsBloc;

  MyApp({Key key, this.hackerNewsBloc, this.prefsBloc}) : super(key: key);

  static const primaryColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        canvasColor: Colors.black,
        textTheme: Theme.of(context).textTheme.copyWith(
            caption: TextStyle(color: Colors.white54),
            subtitle2: TextStyle(fontFamily: 'Abril Fatface')),
      ),
      home: MyHomePage(
        hackerNewsBloc: hackerNewsBloc,
        prefsBloc: prefsBloc,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.hackerNewsBloc, this.prefsBloc}) : super(key: key);
  final HackerNewsBloc hackerNewsBloc;
  final PrefsBloc prefsBloc;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Headline(
            text: const [
              'Flutter Hacker News: Top',
              'Flutter Hacker News: New',
              '...'
            ][_currentIndex],
            index: _currentIndex),
        leading: LoadingInfo(bloc: widget.hackerNewsBloc),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final Article result = await showSearch(
                  context: context,
                  delegate: ArticleSearch(_currentIndex == 0
                      ? widget.hackerNewsBloc.topArticles
                      : widget.hackerNewsBloc.newArticles));

              if (result != null) {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(result.title)));
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return HackerNewsWV(result.url);
                  },
                ));
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<UnmodifiableListView<Article>>(
        stream: _currentIndex == 0
            ? widget.hackerNewsBloc.topArticles
            : widget.hackerNewsBloc.newArticles,
        initialData: UnmodifiableListView<Article>([]),
        builder: (context, snapshot) {
          return ListView(
            key: PageStorageKey(_currentIndex),
            children: snapshot.data
                .map((a) => _Item(article: a, prefsBloc: widget.prefsBloc))
                .toList(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              label: 'Top Stories', icon: Icon(Icons.arrow_drop_up)),
          BottomNavigationBarItem(
              label: 'New Stories', icon: Icon(Icons.new_releases)),
          BottomNavigationBarItem(
              label: 'Preferences', icon: Icon(Icons.settings))
        ],
        onTap: (index) {
          if (index == 0) {
            widget.hackerNewsBloc.storiesType.add(StoriesType.topStories);
          } else if (index == 1) {
            widget.hackerNewsBloc.storiesType.add(StoriesType.newStories);
          } else {
            _showPrefsSheet(context, widget.prefsBloc);
          }
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  void _showPrefsSheet(BuildContext context, PrefsBloc bloc) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Scaffold(
              body: Center(
            child: StreamBuilder<PrefsSate>(
                stream: bloc.currentPrefs,
                builder: (context, AsyncSnapshot<PrefsSate> snapshot) {
                  return snapshot.hasData
                      ? Switch(
                          value: snapshot.data.showWebView,
                          onChanged: (value) {
                            bloc.showWebViewPref.add(value);
                          },
                        )
                      : Text('Nothing');
                }),
          ));
        });
  }
}

class _Item extends StatelessWidget {
  final Article article;
  final PrefsBloc prefsBloc;

  const _Item({Key key, @required this.article, @required this.prefsBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(article.title != null);
    return Padding(
        key: PageStorageKey(article.title),
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
        child: ExpansionTile(
          title: Text(
            article.title,
            style: TextStyle(fontSize: 18.0),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('${article.descendants} comments'),
                      SizedBox(width: 16.0),
                      IconButton(
                        onPressed: () =>
                            Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return HackerNewsWV(article.url);
                          },
                        )),
                        color: Colors.green,
                        icon: Icon(Icons.launch),
                      )
                    ],
                  ),
                  StreamBuilder<PrefsSate>(
                    stream: prefsBloc.currentPrefs,
                    builder: (BuildContext context,
                        AsyncSnapshot<PrefsSate> snapshot) {
                      if (snapshot.data?.showWebView == true) {
                        return Container(
                            height: 200,
                            child: WebView(
                              initialUrl: article.url,
                              javascriptMode: JavascriptMode.unrestricted,
                              gestureRecognizers: Set()
                                ..add(Factory<VerticalDragGestureRecognizer>(
                                    () => VerticalDragGestureRecognizer())),
                            ));
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class LoadingInfo extends StatefulWidget {
  final HackerNewsBloc bloc;

  LoadingInfo({this.bloc});

  @override
  _LoadingInfoState createState() => _LoadingInfoState();
}

class _LoadingInfoState extends State<LoadingInfo>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.bloc.isLoading,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data) {
          _controller.forward().then((value) => _controller.reverse());
          return FadeTransition(
            child: Icon(FontAwesomeIcons.hackerNewsSquare),
            opacity: Tween(begin: 0.5, end: 1.0).animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeIn)),
          );
        } else {
          _controller.reverse();
          return Container();
        }
      },
    );
  }
}

class HackerNewsWV extends StatelessWidget {
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Web page')),
      body: WebView(
          initialUrl: this.url, javascriptMode: JavascriptMode.unrestricted),
      //floatingActionButton: FloatingActionButton(
      //  child: Icon(Icons.favorite),
      //  onPressed: () {},
      //),
    );
  }

  HackerNewsWV(this.url);
}

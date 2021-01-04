import 'dart:collection';
import 'package:flutter/material.dart';
import '../article.dart';

class ArticleSearch extends SearchDelegate<Article> {
  final Stream<UnmodifiableListView<Article>> articles;

  ArticleSearch(this.articles);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: articles,
      builder: (BuildContext context,
          AsyncSnapshot<UnmodifiableListView<Article>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text('No data!'));
        }

        var results = snapshot.data
            .where((element) => element.title.toLowerCase().contains(query));

        return ListView(
          children: results
              .map<ListTile>((e) => ListTile(
            title: Text(
              e.title,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(fontSize: 16.0, color: Colors.blue),
            ),
            leading: Icon(Icons.book),
            onTap: () {
              close(context, e);
            },
          ))
              .toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: articles,
      builder: (BuildContext context,
          AsyncSnapshot<UnmodifiableListView<Article>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text('No data!'));
        }

        final results =
        snapshot.data.where((element) => element.title.contains(query));

        return ListView(
          children: results
              .map<ListTile>((e) => ListTile(
            title: Text(
              e.title,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(fontSize: 16.0),
            ),
            //leading: Icon(Icons.book),
            onTap: () {
//                      query = e.title;
              close(context, e);
            },
          ))
              .toList(),
        );
      },
    );
  }
}

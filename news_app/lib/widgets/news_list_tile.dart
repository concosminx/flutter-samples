import 'package:flutter/material.dart';
import 'package:news_app/widgets/loading_container.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';

class NewsListTile extends StatelessWidget {
  final int? itemId;

  NewsListTile({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        return FutureBuilder(
          future: snapshot.data?[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return LoadingContainer();
            }
            return buildTile(context, itemSnapshot.data!);
          },
        );
      },
    );
  }

  Widget buildTile(BuildContext context, ItemModel item) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(item.title),
          subtitle: Text('${item.score} votes'),
          trailing: Column(
            children: <Widget>[
              Icon(Icons.comment),
              Text('${item.descendants}')
            ],
          ),
          onTap: () {
            Navigator.pushNamed(context, '/${item.id}');
          },
        ),
        Divider(
          height: 8.0,
        ),
      ],
    );
  }
}

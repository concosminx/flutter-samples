import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'loading_container.dart';

class Comment extends StatelessWidget {

  final int? itemId;
  final Map<int, Future<ItemModel>>? itemMap;
  final int? depth;

  Comment({this.itemId, this.itemMap, this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap?[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        final commentsList = snapshot.data?.kids.map((commentId) {
          return Comment(
            itemId: commentId,
            itemMap: itemMap,
            depth: this.depth! + 1,
          );
        }).toList();

        final item = snapshot.data;

        return Column(
          children: <Widget>[
            ListTile(
              title: buildText(item!),
              subtitle: item.by == "" ? Text('Deleted') : Text(item.by),
              contentPadding: EdgeInsets.only(
                right: 16.0,
                left: (depth! + 1) * 16.0
              ),
            ),
            Divider(),
            ...commentsList!
          ],
        );
      },
    );
  }

  Widget buildText(ItemModel item) {
    final text = item.text
        .replaceAll('&#x27', "'")
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '');
    return Text(text);
  }

}

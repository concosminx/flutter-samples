import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/image_model.dart';
import 'dart:convert';
import 'widgets/image_list.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  List<ImageModel> images= [];
  int counter = 0;

  void fetchImage () async {
    counter++;
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos/$counter'));
    setState(() {
      images.add(ImageModel.fromJson(json.decode(response.body)));
    });
  }

  Widget build(context) {
    return MaterialApp(
        title: 'Pics App',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Lets see some pictures'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: fetchImage,
            child: Icon(Icons.add),
          ),
          body: ImageList(
            this.images
          ),
        )
    );
  }
}

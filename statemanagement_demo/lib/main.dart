import 'package:flutter/material.dart';
import 'package:itshare_statemanagement_demo/app_view_model.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import 'second_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppViewModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
        routes: {
          '/second-page': (context) => SecondPage(),
        },
      ),
    );
  }
}

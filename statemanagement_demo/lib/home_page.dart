import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_view_model.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  void goToSecondScreen(BuildContext context) {
    Navigator.of(context).pushNamed('/second-page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Consumer<AppViewModel>(
              builder: (context, viewModel, _) => Text(
                viewModel.counter.toString(),
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToSecondScreen(context),
        tooltip: 'Go to second page',
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:itshare_statemanagement_demo/app_view_model.dart';
import 'package:provider/provider.dart';

class SecondPage extends StatelessWidget {
  SecondPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Press the button to increment the counter',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Provider.of<AppViewModel>(context, listen: false)
            .incrementCounter(),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

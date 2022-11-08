import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: Home(),
));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('my first app :)'),
          centerTitle: true,
          backgroundColor: Colors.red[600]
      ),
      body: Row(
        children: <Widget>[
          Expanded(child: Image.asset('assets/space-2.jpg')),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(30.0),
              color: Colors.cyan,
              child: Text('1'),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(30.0),
              color: Colors.pinkAccent,
              child: Text('2'),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(30.0),
              color: Colors.amber,
              child: Text('3'),
            ),
          ),
        ],
      ),
//      body: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Text('hello world'),
//          FlatButton(
//            onPressed: () {},
//            color: Colors.amber,
//              child: Text('click me'),
//          ),
//          Container(
//            color: Colors.cyan,
//            padding: EdgeInsets.all(30),
//            child: Text('inside container'),
//          ),
//          Column(
//            children: <Widget>[
//              Container(
//                padding: EdgeInsets.all(5),
//                color: Colors.cyan,
//                child: Text('one'),
//              ),
//              Container(
//                padding: EdgeInsets.all(15),
//                color: Colors.pinkAccent,
//                child: Text('two'),
//              ),
//              Container(
//                padding: EdgeInsets.all(25),
//                color: Colors.amber,
//                child: Text('three'),
//              ),
//            ],
//          )
//        ],
//      ),
//      body: Padding(
//        child: Text('hello'),
//        padding: EdgeInsets.all(90),
//      ),
//      body: Container(
//        padding: EdgeInsets.fromLTRB(10, 20, 30, 40),
//        margin: EdgeInsets.all(30),
//        color: Colors.grey[400],
//        child: Text('hello'),
//      ),
      //Center(
        //child: Image.asset('assets/space-3.jpg'),
//        child: Icon(
//          Icons.card_membership,
//          color: Colors.lightBlue,
//          size: 50,
//        ),
//      child: RaisedButton.icon(
//        onPressed: () {
//          print('you clicked me');
//        },
//        icon: Icon(
//          Icons.mail
//        ),
//        label: Text('mail me'),
//      ),
//      child: IconButton(
//        onPressed: () {
//          print('you clicked me');
//          },
//        icon: Icon(Icons.ac_unit),
//        color: Colors.amber
//      )

//      ),
//      floatingActionButton: FloatingActionButton(
//        backgroundColor: Colors.red[600],
//        child: Text('click'),
//      ),
    );
  }
}
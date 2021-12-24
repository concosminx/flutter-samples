import 'package:flutter/material.dart';

class AppViewModel extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }
}

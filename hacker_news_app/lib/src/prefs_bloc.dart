import 'dart:async';
import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';

import 'article.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class PrefsSate {
  final bool showWebView;

  const PrefsSate(this.showWebView);
}

class PrefsBloc {

  final _currentPrefs = BehaviorSubject<PrefsSate>();

  final _showWebViewPref = StreamController<bool>();

  PrefsBloc() {
    _loadSharedPrefs();
    _showWebViewPref.stream.listen((event) {
      _saveNewPrefs(PrefsSate(event));
    });
  }

  Stream<PrefsSate> get currentPrefs => _currentPrefs.stream;

  Sink<bool> get showWebViewPref => _showWebViewPref.sink;

  Future<void> _loadSharedPrefs() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final showWebView = sharedPrefs.getBool('showWebView') ?? true;
    _currentPrefs.add(PrefsSate(showWebView));
  }

  Future<void> _saveNewPrefs(PrefsSate newState) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setBool('showWebView', newState.showWebView);
    _currentPrefs.add(newState);
  }

  dispose() {
    _currentPrefs.close();
    _showWebViewPref.close();
  }
}

class PrefsBlocApiError extends Error {
  final String message;

  PrefsBlocApiError(this.message);
}

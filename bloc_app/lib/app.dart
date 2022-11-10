import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'blocs/provider.dart';

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Log Me In',
        home: Scaffold(
          body: LoginScreen(),
        ),
      ),
    );
  }
}

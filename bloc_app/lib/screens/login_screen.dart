import 'package:flutter/material.dart';
import '../blocs/provider.dart';
import '../blocs/bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            emailField(bloc),
            passwordField(bloc),
            Container(
              margin: const EdgeInsets.only(top: 25.0),
            ),
            submitField(bloc)
          ],
        ));
  }

  Widget emailField(Bloc bloc) {
    return StreamBuilder(
        stream: bloc.email,
        builder: (context, snapshot) {
          return TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: bloc.changeEmail,
            decoration: InputDecoration(
                labelText: 'Email address',
                hintText: 'you@example.com',
                errorText: snapshot.error?.toString() ?? ''),
          );
        });
  }

  Widget passwordField(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          obscureText: true,
          onChanged: bloc.changePassword,
          decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Password',
              errorText: snapshot.error?.toString() ?? ''),
        );
      },
    );
  }

  Widget submitField(Bloc bloc) {



    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return ElevatedButton(
          onPressed: snapshot.hasData ? bloc.submit : null,
          style: TextButton.styleFrom(foregroundColor: Colors.lightBlue),
          child: const Text("Submit!")
        );
      },
    );
  }
}

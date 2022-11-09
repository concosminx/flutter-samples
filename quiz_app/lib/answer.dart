import 'package:flutter/material.dart';

class Answer extends StatelessWidget {

  final VoidCallback selectHandler;
  final String answerText;

  const Answer(this.selectHandler, this.answerText, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        //color: Colors.blue,
        //textColor: Colors.white,
        onPressed: selectHandler,
        child: Text(answerText),
      ),
    );
  }
}

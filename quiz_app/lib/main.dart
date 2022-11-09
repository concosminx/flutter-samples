import 'package:flutter/material.dart';
import './quiz.dart';
import './result.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _questionIndex = 0;
  int _totalScore = 0;

  final _questions = const [
    {
      'questionText': 'What is the most common colour of toilet paper in France?',
      'answers': [
        {'text': 'White', 'score': 10},
        {'text': 'Red', 'score': 6},
        {'text': 'Green', 'score': 3},
        {'text': 'Pink', 'score': 1}
      ]
    },
    {
      'questionText': 'What is Scooby Doo’s full name?',
      'answers': [
        {'text': 'Scooby-Doo, Where Are You', 'score': 10},
        {'text': 'Scooby Doo', 'score': 6},
        {'text': 'Edson Arantes do Nascimento Doo', 'score': 3},
        {'text': 'Scoobert Doo', 'score': 1}
      ]
    },
    {
      'questionText': 'The average person does what thirteen times a day?',
      'answers': [
        {'text': 'Sleeps', 'score': 10},
        {'text': 'Yawnn', 'score': 6},
        {'text': 'Speaks', 'score': 3},
        {'text': 'Laughs', 'score': 1}
      ]
    },
  ];

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;
    setState(() {
      _questionIndex++;
    });
    //print(_questionIndex);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text('Quiz app ?!'),
          ),
          body: _questionIndex < _questions.length
              ? Quiz(
              questions: _questions,
              answerQuestion: _answerQuestion,
              questionIndex : _questionIndex
          )
              : Result(_totalScore, _resetQuiz),
        ));
  }
}

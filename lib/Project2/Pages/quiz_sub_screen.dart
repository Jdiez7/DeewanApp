import 'package:appwithfirebase/Project2/Pages/quizNotReady.dart';
import 'package:appwithfirebase/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:provider/provider.dart';

import '../../models/myuser.dart';
import '../../services/class_vocab.dart';
import '../../services/database.dart';

class subQuiz extends StatefulWidget {
  final int level;


  subQuiz(
    this.level, {
    Key? key,
  }) : super(key: key);

  @override
  _subQuizState createState() => _subQuizState();
}

class _subQuizState extends State<subQuiz> {
  List<Icon> _scoreTracker = [Icon(null),Icon(null),Icon(null),Icon(null),Icon(null),Icon(null),Icon(null),Icon(null),Icon(null),Icon(null),Icon(null),Icon(null)];
  int _questionIndex = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;
  bool questionsCreated = false;
  int _quizLength = 10;
  final int count = 0;
  final double _pass = 0.7;
  final _random = new Random();
  List _questions = initial;

  @override

  void _questionAnswered(bool answerScore, List<int> _previousDone) {
    setState(() {
      answerWasSelected = true;
      if (answerScore) {
        _totalScore++;
        correctAnswerSelected = true;
      }
      _scoreTracker[_questionIndex+1] = answerScore
          ? Icon(
              Icons.check_circle,
              color: Colors.green,
            )
          : Icon(
              Icons.clear,
              color: Colors.red,
            );
      if (_questionIndex + 1 == _quizLength) {
        _totalScore > _pass * _quizLength ? _previousDone.add(widget.level+1) : null;
        print(_previousDone);
        MyUser user = Provider.of<MyUser>(context, listen: false);
        DeewanDataBaseService(uid: user.uid)
            .updateDoneLevel(
            _previousDone);

        endOfQuiz = true;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      answerWasSelected = false;
      correctAnswerSelected = false;
    });
    if (_questionIndex >= _quizLength) {
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 1);
      _questionIndex = 0;
      //_resetQuiz();
    }
  }

  void _createVocabs(_vocabs) {
    if (!questionsCreated){
      _questions = _randomList(_vocabs);
    }
    questionsCreated = true;
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _scoreTracker = [Icon(null),Icon(null),Icon(null),Icon(null),Icon(null),Icon(null),Icon(null),Icon(null),Icon(null),Icon(null),Icon(null),Icon(null)];
      endOfQuiz = false;
      questionsCreated = false;
    });
  }

  _randomList(_vocabs) {
    final List _questions = [];
    List<int> _numberList=[];
    for (var i = 0; i < 10;){
      int random_number = _random.nextInt(_vocabs.length);
      if (!_numberList.contains(random_number)) {
        _numberList.add(random_number);
        List<int> _thisQuestion = [_numberList[i] as int];
        for (var j = 0; j < 4; j++){
          int _random_answer = _random.nextInt(_vocabs.length);
          if (!_thisQuestion.contains(_random_answer)) {
            _thisQuestion.add(_random_answer);}
        }
        List<String> _answers = [];
        final bool _whichQuestion = _random.nextBool();
        print(_whichQuestion.toString());
        _whichQuestion ?
         _answers = [
          _vocabs[_numberList[i]].arabicMain,
          _vocabs[_thisQuestion[1]].arabicMain,
          _vocabs[_thisQuestion[2]].arabicMain,
      _vocabs[_thisQuestion[3]].arabicMain,
           _vocabs[_numberList[i]].englishMain,
        ]: _answers = [
    _vocabs[_numberList[i]].englishMain,
    _vocabs[_thisQuestion[1]].englishMain,
    _vocabs[_thisQuestion[2]].englishMain,
    _vocabs[_thisQuestion[3]].englishMain,
          _vocabs[_numberList[i]].arabicMain,
    ];
        List<bool> _scores = [true,false,false,false];
        List _reihenfolge = [0,1,2,3];
        _reihenfolge.shuffle();

        _questions.add({'question': _answers[4],
          'answers': [
            {'answerText': _answers[_reihenfolge[0]], 'score': _scores[_reihenfolge[0]]},
            {'answerText': _answers[_reihenfolge[1]], 'score': _scores[_reihenfolge[1]]},
            {'answerText': _answers[_reihenfolge[2]], 'score': _scores[_reihenfolge[2]]},
            {'answerText': _answers[_reihenfolge[3]], 'score': _scores[_reihenfolge[3]]},
          ],
          'id' : _vocabs[_numberList[i]].id,
        },);
        i++;
      }
      print(_questions.length);
    }
    return _questions;
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<List<Vocab>>(
      stream: DeewanDataBaseService().backendVocabs,
      builder: (context, snapshot) {
    if (snapshot.hasData) {
      List<Vocab> allVocabs = snapshot.data!;
      List<Vocab> levelVocabs = allVocabs.where((i) => i.lvl.contains(widget.level.toString())).toList();
      if (levelVocabs.length < 10 || levelVocabs.length < _quizLength)
      {
        Future.delayed(Duration.zero, () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => quizNotReady(widget.level)));
        });
        return Loading();
      } else { _createVocabs(levelVocabs);

      MyUser user = Provider.of<MyUser>(context);
      return StreamBuilder<DeewanUserData>(
          stream: DeewanDataBaseService(uid: user.uid).deewanUserData,
        builder: (context, snapshot) {
    if (snapshot.hasData) {
      DeewanUserData deewanUserData = snapshot.data!;
      List<int> _previousDone = List.from(deewanUserData.doneLevels!);
      print(_previousDone);
          return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.blue,
                  title: Text('Quiz - Level ' + widget.level.toString()),
                ),
                body: Container(
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/app_bg5.jpg"),
                          fit: BoxFit.cover,
                          colorFilter:
                          ColorFilter.mode(Colors.black.withOpacity(0.1),
                              BlendMode.dstATop),)),

                    child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (_scoreTracker.length == 0)
                            SizedBox(
                              height: 25.0,
                            ),
                          if (_scoreTracker.length > 0) ..._scoreTracker
                        ],
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Container(
                          width: double.infinity,
                          height: 160.0,
                          margin:
                              EdgeInsets.only(bottom: 10.0, left: 30.0, right: 30.0),
                          padding:
                              EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular((10.0))),
                          child: Center(
                              child: Text(
                            'Give me the correct translation for \n \n' + _questions[_questionIndex]['question'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))),
                      ...(_questions[_questionIndex]['answers']
                      as List<Map<String,Object>>).map((answer) => Answer(
                        answerText: answer['answerText'].toString(),
                        answerColor: answerWasSelected ? answer['score'] as bool ?
                            Colors.green : Colors.red : Colors.blue,
                        answerTap: (){
                          if (answerWasSelected){
                            return;
                          }
                          final _grade = answer['score'] as bool;
                          if (!_grade){
                            List _oldForgotten = List.from(deewanUserData.forgottenVocab!);
                            print(_oldForgotten);
                            _oldForgotten.add(_questions[_questionIndex]['id']);
                            print(_oldForgotten);
                            deewanUserData.myFavoriteVocabs.contains(_questions[_questionIndex]['id']) ? null:
                            DeewanDataBaseService(uid: deewanUserData.uid)
                                .updateForgottenVocab(
                                _oldForgotten);
                          }
                          _questionAnswered(answer['score'] as bool, _previousDone as List<int>);
                        },
                      )),
                      SizedBox(height: 20,),

                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 40.0),
                          ),
                          onPressed: (){
                            if (!answerWasSelected){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text( 'Please select an answer before going to the next section'),));
                              return;
                            }
                            _nextQuestion();
                          }, child: Text(endOfQuiz? 'Restart Quiz' : 'Next Question')),
                      Container(padding: EdgeInsets.all(20.0),
                      child: Text(
                        '${_totalScore.toString()}/${_quizLength}',
                        style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                      )),
                      if (answerWasSelected && !endOfQuiz)
                        Container(
                          height: 100,
                            width: double.infinity,
                          color: correctAnswerSelected? Colors.green : Colors.red,
                          child: Center(
                            child: Text(
                              correctAnswerSelected ? 'Well Done!' : 'Wrong :/',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          ),
                        ),
                      if (endOfQuiz)
                        Container(
                                  height: 100,
                                  width: double.infinity,
                                  color: Colors.black,
                                  child: Center(
                                    child: Text(
                                        _totalScore > _pass * _quizLength
                                            ? 'Congrats! You made it to the next level!'
                                            : 'Your score is $_totalScore/$_quizLength. Try Again!',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: _totalScore > _pass * _quizLength
                                              ? Colors.green
                                              : Colors.red,
                                        )),
                                  ),
                                )
                            ],
                  ),
                )));
    }else {
      return Loading();
    } }
      );
      }}else {
      return Loading();
    }}
    );
  }
}

class Answer extends StatelessWidget {
  final String answerText;
  final Color answerColor;
  final VoidCallback answerTap;

  const Answer({Key? key, required this.answerText, required this.answerColor, required this.answerTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: answerTap,
      child: Container(
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: answerColor,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Text(
          answerText,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white,
          )
        ),
      )),
    );
  }
}

final initial = const [
  {
    'question': 'Null',
    'answers': [
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
    ],
  },
  {
    'question': 'Null',
    'answers': [
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
    ],
  },
  {
    'question': 'Null',
    'answers': [
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
    ],
  },
  {
    'question': 'Null',
    'answers': [
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
    ],
  },
  {
    'question': 'Null',
    'answers': [
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
    ],
  },
  {
    'question': 'Null',
    'answers': [
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
    ],
  },
  {
    'question': 'Null',
    'answers': [
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
    ],
  },
  {
    'question': 'Null',
    'answers': [
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
    ],
  },
  {
    'question': 'Null',
    'answers': [
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
    ],
  },
  {
    'question': 'Null',
    'answers': [
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
      {'answerText': 'Null', 'score': false},
    ],
  },
];
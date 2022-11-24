import 'package:appwithfirebase/Project2/Pages/quiz_sub_screen.dart';
import 'package:appwithfirebase/screens/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/deewani_deewanuser.dart';
import '../../models/myuser.dart';
import '../../services/database.dart';
import '../../shared/loading.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  Widget _buildList(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    return StreamBuilder<DeewanUserData>(
        stream: DeewanDataBaseService(uid: user.uid).deewanUserData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DeewanUserData deewanUserData = snapshot.data!;
            final int _Listlength;
              _Listlength = 10;
            final List _done = deewanUserData.doneLevels as List;
            return ListView.separated(
              itemCount: 9,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                final level = index +1;
                return ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  tileColor: _done.contains(level+1)  ? Colors.blue : _done.contains(level) || level == 1 ? Colors.green : Colors.grey,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Level ' + level.toString() + " - " + _levelNames[index],
                    style: TextStyle(fontSize: 17, color: Colors.white,fontWeight: FontWeight.bold), ),
                    ],
                  ),
                  onTap: () {
                    _done.contains(level) || level == 1 ?
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => subQuiz(level)),
                    )
                        : null;
                  },
                  trailing:Icon(
                          _done.contains(level)|| level == 1 ?
                          Icons.forward : Icons.lock),
                     );
              }, separatorBuilder: (BuildContext context, int index) => SizedBox(
                height: 10,
            ));
          } else {
            return Loading();
          }
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Quiz'),
        ),
        /*actions: <Widget>[
              IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
            ]),*/
        body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/app_bg5.jpg"),
                  fit: BoxFit.cover,
                  colorFilter:
                  ColorFilter.mode(Colors.black.withOpacity(0.1),
                      BlendMode.dstATop),)),

            child: _buildList(context)

        )
    );
  }
}

final _levelNames = [
  "Beginner Low",
  "Beginner Mid",
  "Beginner High",
  "Intermediate Low",
  "Intermediate Mid",
  "Intermediate High",
  "Advanced Low",
  "Advanced Mid",
  "Advanced High",
  "",];


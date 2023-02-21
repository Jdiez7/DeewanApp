import 'package:appwithfirebase/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/myuser.dart';
import '../../services/database.dart';
import '../../shared/loading.dart';

class quizNotReady extends StatelessWidget {
  final int level;
  const quizNotReady(this.level,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context, listen: false);
    return StreamBuilder<DeewanUserData>(

    stream: DeewanDataBaseService(uid: user.uid).deewanUserData,
    builder: (context, snapshot) {
    if (snapshot.hasData) {
      DeewanUserData deewanUserData = snapshot.data!;
      List<int> _previousDone = List.from(deewanUserData.doneLevels!);

      return Scaffold(
          appBar: AppBar(
            leading: Icon(null),
            title: Text('The Quiz for Level $level is not ready'),
          )
          ,
          body: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/app_bg5.jpg"),
                    fit: BoxFit.cover,
                    colorFilter:
                    ColorFilter.mode(Colors.black.withOpacity(0.1),
                        BlendMode.dstATop),)),

              child: Column(
            children: [
              SizedBox(
                height: 50.0,
              ),
              Center(
            child: Text("We are working on it")
          ),SizedBox(
                height: 250.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  maximumSize: Size(double.infinity,40),
                  backgroundColor: globalColor1,
                ),
          onPressed: () {
            _previousDone.add(level+1);
            DeewanDataBaseService(uid: user.uid)
                .updateDoneLevel(
                _previousDone);
            int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);},
          child: Text('Get Back and skip this Level'),
        )],

        )));
    }else {
      return Loading();
    }}
    );
  }
}


import 'package:appwithfirebase/Project2/Pages/admin_requested_screen.dart';
import 'package:appwithfirebase/Project2/Search/search.dart';
import 'package:appwithfirebase/Project2/TEST/TestSearch.dart';
import 'package:appwithfirebase/services/class_vocab.dart';
import 'package:appwithfirebase/shared/constants.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Pages/favorite_screen.dart';
import 'Pages/quiz_page.dart';
import 'Pages/favorite_words.dart';
import 'Pages/learning_material.dart';
import 'Pages/My_Account.dart';
import 'Pages/quiz_screen.dart';
import 'Pages/refer_to_a_friend.dart';
import 'Pages/request_screen.dart';
import 'dart:async';
import 'dart:io';



class MyMenu extends StatelessWidget{

  final String title;
  final IconData icon;
  final Color warna;
  final List<int> favoriteVocabs;
  //final List<Vocab> vocabs;

  MyMenu({this.title = 'ERROR', this.icon = Icons.error, this.warna = globalColor1, required this.favoriteVocabs,/*required this.vocabs*/});



  @override
  Widget build(BuildContext context){
    final vocabs = Provider.of<List<Vocab>>(context);
    return  Card(

        margin: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchWordScreen(vocabs, favoriteVocabs)),
              );
            },
            splashColor: globalColor1,
            child: Center(
                child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(icon, size:70.0, color: warna,),
                    Text(title, style : const TextStyle(fontSize: 17.0))
                  ],
                )
            )
        )
    );
  }
}

class TestVocabs extends StatelessWidget{


  final String title;
  final IconData icon;
  final Color warna;
  final List<int> favoriteVocabs;
  //final List<Vocab> vocabs;

  TestVocabs({this.title = 'ERROR', this.icon = Icons.error, this.warna = Colors.purple, required this.favoriteVocabs,/*required this.vocabs*/});

  Future<List<TestV>> _loadCSV() async {
    final _rawData1 = await rootBundle.loadString("assets/test1.csv");
    final _rawData2 = await rootBundle.loadString("assets/test2.csv");
    final _rawData3 = await rootBundle.loadString("assets/test3.csv");

    List<List<dynamic>> _listData1 = CsvToListConverter().convert(_rawData1, eol: '\n', fieldDelimiter: ',');
    List<List<dynamic>> _listData2 = CsvToListConverter().convert(_rawData2, eol: '\n', fieldDelimiter: ',');
    List<List<dynamic>> _listData3 = CsvToListConverter().convert(_rawData3, eol: '\n', fieldDelimiter: ',');

    var _listData = _listData1 + _listData2 +_listData3;
    print(_listData.length);
    List<TestV> returnList = _listData // Skip the header row
        .map((parts) {
      return TestV(
        id: parts[1] is int ? parts[1] as int : 0,
        englisch1: parts[2] != null ? parts[2].startsWith("1. ") ?  parts[2].toString().substring(3,) :parts[2] : "Empty",
        englisch2: parts[3] != null ? parts[3].toString() : "Empty",
        englisch3: parts[4] != null ? parts[4].toString() : "Empty",
        englisch4: parts[5] != null ? parts[5] : "Empty",
        englisch5: parts[6] != null ? parts[6]: "Empty",
        englisch6: parts[7] != null ? parts[7] : "Empty",
        englisch7: parts[8] != null ? parts[8] : "Empty",
        englisch8: parts[9] != null ? parts[9] : "Empty",
        arabic1: parts[10] != null ? parts[10] == "(أ / إ)"? parts[11] : parts[10]: "Empty",
        arabic2: parts[11] != null ? parts[10] == "(أ / إ)"? parts[12] : parts[11] : "Empty",
        arabic3: parts[12] != null ? parts[10] == "(أ / إ)"? parts[13] : parts[12] : "Empty",
        arabic4: parts[13] != null ? parts[13] : "Empty",
        forms1: parts[14] != null ? parts[14]: "Empty",
        forms2: parts[15] != null ? parts[15] : "Empty",
        forms3: parts[16] != null ? parts[16] : "Empty",);}
    ).toList();
    print('Hi');
    return returnList;
  }


  @override

  Widget build(BuildContext context){

    return  Card(

        margin: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: () async {
              // final String load = await rootBundle.loadString("assets/test1.csv");
              List<TestV> testVocabs = await _loadCSV();
              print(testVocabs.length);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TestVocabsScreen(testVocabs, favoriteVocabs)),
              );
            },
            splashColor: globalColor1,
            child: Center(
                child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(icon, size:70.0, color: warna,),
                    Text(title, style : const TextStyle(fontSize: 17.0))
                  ],
                )
            )
        )
    );
  }
}

class FavoriteVocabs extends StatelessWidget{

  final String title;
  final IconData icon;
  final Color warna;
  final List<int> favoriteVocabs;
  //final List<Vocab> vocabs;

  FavoriteVocabs({this.title = 'ERROR', this.icon = Icons.error, this.warna = Colors.purple, required this.favoriteVocabs, /*required this.vocabs,*/});


  @override
  Widget build(BuildContext context){
    final vocabs = Provider.of<List<Vocab>>(context);
    return  Card(

        margin: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteScreen(vocabs,)),
              );
            },
            splashColor: globalColor1,
            child: Center(
                child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(icon, size:70.0, color: warna,),
                    Text(title, style : const TextStyle(fontSize: 17.0))
                  ],
                )
            )
        )
    );
  }
}

class MyMenu3 extends StatelessWidget{

  final String title;
  final IconData icon;
  final Color warna;

  MyMenu3({this.title = 'ERROR', this.icon = Icons.error, this.warna = Colors.purple,});


  @override
  Widget build(BuildContext context){
    return  Card(

        margin: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => quiz_page()),
              );
            },
            splashColor: warna,
            child: Center(
                child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(icon, size:70.0, color: warna,),
                    Text(title, style : const TextStyle(fontSize: 17.0))
                  ],
                )
            )
        )
    );
  }
}

class WordRequest extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color warna;

  WordRequest({this.title = 'ERROR', this.icon = Icons.error, this.warna = Colors.purple,});


  @override
  Widget build(BuildContext context) {
    return  Card(

        margin: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RequestScreen()),
              );
            },
            splashColor: warna,
            child: Center(
                child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(icon, size:70.0, color: warna,),
                    Text(title, style : const TextStyle(fontSize: 17.0))
                  ],
                )
            )
        )
    );

  }
}

class Quiz extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color warna;

  Quiz({this.title = 'ERROR', this.icon = Icons.error, this.warna = Colors.purple,});


  @override
  Widget build(BuildContext context) {
    return  Card(

        margin: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizScreen()),
              );
            },
            splashColor: warna,
            child: Center(
                child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(icon, size:70.0, color: warna,),
                    Text(title, style : const TextStyle(fontSize: 17.0))
                  ],
                )
            )
        )
    );

  }
}

class AdminWordsRequested extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color warna;

  AdminWordsRequested({this.title = 'ERROR', this.icon = Icons.error, this.warna = Colors.purple,});


  @override
  Widget build(BuildContext context) {
    return  Card(

        margin: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminRequestedScreen()),
              );
            },
            splashColor: globalColor1,
            child: Center(
                child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(icon, size:70.0, color: warna,),
                    Text(title, style : const TextStyle(fontSize: 17.0))
                  ],
                )
            )
        )
    );

  }
}

class MyMenu4 extends StatelessWidget{

  final String title;
  final IconData icon;
  final Color warna;

  MyMenu4({this.title = 'ERROR', this.icon = Icons.error, this.warna = Colors.purple,});


  @override
  Widget build(BuildContext context){
    return  Card(

        margin: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => learning_material()),
              );
            },
            splashColor: globalColor1,
            child: Center(
                child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(icon, size:70.0, color: warna,),
                    Text(title, style : const TextStyle(fontSize: 17.0))
                  ],
                )
            )
        )
    );
  }
}

class MyMenu5 extends StatelessWidget{

  final String title;
  final IconData icon;
  final Color warna;

  MyMenu5({this.title = 'ERROR', this.icon = Icons.error, this.warna = Colors.purple,});


  @override
  Widget build(BuildContext context){
    return  Card(

        margin: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => my_account()),
              );
            },
            splashColor: globalColor1,
            child: Center(
                child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(icon, size:70.0, color: warna,),
                    Text(title, style : const TextStyle(fontSize: 17.0))
                  ],
                )
            )
        )
    );
  }
}

class MyMenu6 extends StatelessWidget{

  final String title;
  final IconData icon;
  final Color warna;

  MyMenu6({this.title = 'ERROR', this.icon = Icons.error, this.warna = Colors.purple,});


  @override
  Widget build(BuildContext context){
    return  Card(

        margin: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => refer_to_a_friend()),
              );
            },
            splashColor: globalColor1,
            child: Center(
                child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(icon, size:70.0, color: warna,),
                    Text(title, style : const TextStyle(fontSize: 17.0))
                  ],
                )
            )
        )
    );
  }
}
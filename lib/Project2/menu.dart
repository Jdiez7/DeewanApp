import 'package:appwithfirebase/Project2/Search/search.dart';
import 'package:appwithfirebase/Project2/Search/vocab.dart';
import 'package:flutter/material.dart';
import 'Pages/favorite_screen.dart';
import 'Pages/quiz_page.dart';
import 'Pages/favorite_words.dart';
import 'Pages/learning_material.dart';
import 'Pages/My_Account.dart';
import 'Pages/refer_to_a_friend.dart';



class MyMenu extends StatelessWidget{

  final String title;
  final IconData icon;
  final MaterialColor warna;
  final List<int> favoriteVocabs;
  final List<Vocab> vocabs;

  MyMenu({this.title = 'ERROR', this.icon = Icons.error, this.warna = Colors.purple, required this.favoriteVocabs,required this.vocabs});


  @override
  Widget build(BuildContext context){
    return  Card(

        margin: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchWordScreen(vocabs, favoriteVocabs)),
              );
            },
            splashColor: Colors.green,
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
  final MaterialColor warna;
  final List<int> favoriteVocabs;
  final List<Vocab> vocabs;

  FavoriteVocabs({this.title = 'ERROR', this.icon = Icons.error, this.warna = Colors.purple, required this.favoriteVocabs, required this.vocabs,});


  @override
  Widget build(BuildContext context){
    return  Card(

        margin: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteScreen(vocabs, favoriteVocabs)),
              );
            },
            splashColor: Colors.green,
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
  final MaterialColor warna;

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
            splashColor: Colors.green,
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
  final MaterialColor warna;

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
            splashColor: Colors.green,
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
  final MaterialColor warna;

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
            splashColor: Colors.green,
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
  final MaterialColor warna;

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
            splashColor: Colors.green,
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
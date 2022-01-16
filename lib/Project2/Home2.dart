import 'package:flutter/material.dart';
import '../services/auth.dart';
import './menu.dart';
import 'Search/allvocabs.dart';
import 'Search/search.dart';
import 'Search/vocab.dart';

import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';


/*void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Authenticate(),
    );
  }
}*/


//wenn auskommentiert geht die alte app wieder


class Home2 extends StatefulWidget {
  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2>{
  _Home2State({this.accountEmail = 'Hier könnte ihre Mailadresse stehen', this.accountName = 'MAX MUSTERMANN'});

  final String accountName;
  final String accountEmail;
  List<int> favoriteVocab = List<int>.empty(growable: true);
  List<Vocab> vocabs = allVocabs2;
  final AuthService _auth = AuthService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Colors.brown,
        actions: <Widget>[
          ElevatedButton.icon(
      style: ElevatedButton.styleFrom(primary: Colors.brown[300]),
            icon: const Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async{
              await _auth.signOut();
            },
          )
        ],
      ),
      backgroundColor: Colors.brown[100],

      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
                accountName: Text(accountName, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
                accountEmail: Text(accountEmail),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: NetworkImage("https://pic.onlinewebfonts.com/svg/img_335286.png"),
                ),
                decoration: const BoxDecoration(color: Colors.brown),
            ),

            const ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
            ),
            const ListTile(
              leading: Icon(Icons.vpn_key),
              title: Text("Password"),
            ),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text("Information"),
            ),
            const ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Exit"),
            ),
          ],

        ),
      ),

      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: GridView.count(
            crossAxisCount: 2,
            children: <Widget>[
              MyMenu(title: 'Word Search', icon: Icons.search, warna: Colors.brown,vocabs: vocabs, favoriteVocabs: favoriteVocab),
              FavoriteVocabs(title: 'Favorites', icon: Icons.folder, warna: Colors.brown, vocabs: vocabs, favoriteVocabs: favoriteVocab),
              MyMenu3(title: 'Quiz', icon: Icons.quiz, warna: Colors.brown,),
              MyMenu4(title: 'Learning Material', icon: Icons.school, warna: Colors.brown,),
              MyMenu5(title: 'My Account', icon: Icons.account_circle, warna: Colors.brown,),
              MyMenu6(title: 'Refer to a friend', icon: Icons.send, warna: Colors.brown,),
            ],)
      ),
    );
  }
}




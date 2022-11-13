import 'package:appwithfirebase/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Project2/menu.dart';
import '../../services/auth.dart';
import '../../services/class_vocab.dart';
import '../wrapper.dart';

// import 'package:firebase_core/firebase_core.dart';
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


class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>{
  _AdminScreenState({this.accountEmail = 'Hier könnte ihre Mailadresse stehen', this.accountName = 'MAX MUSTERMANN'});

  final String accountName;
  final String accountEmail;
  List<int> favoriteVocab = List<int>.empty(growable: true);
  final AuthService _auth = AuthService();


  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(primary: Colors.blue[300]),
            icon: const Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async{
              await _auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute(
                      builder: (context) =>
                      new Wrapper()),
                      (route) => false);           },
          )
        ],
      ),
      backgroundColor: Colors.white,

      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/app_bg5.jpg"),
              fit: BoxFit.cover,
              colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.4),
                  BlendMode.dstATop),)),


        child: StreamProvider<List<Vocab>>.value(
            value: DeewanDataBaseService().backendVocabs,
            initialData: [],
            builder: (context, snapshot) {
              return Container(
                  padding: const EdgeInsets.all(30.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: <Widget>[
                      MyMenu(title: 'Word Search', icon: Icons.search, warna: Colors.blue,/*vocabs: vocabs,*/ favoriteVocabs: favoriteVocab),
                      FavoriteVocabs(title: 'Favorites', icon: Icons.folder, warna: Colors.blue, /*vocabs: vocabs,*/ favoriteVocabs: favoriteVocab),
                      /*MyMenu3(title: 'Quiz', icon: Icons.quiz, warna: Colors.blue,),
                    */WordRequest(title: 'Word Request', icon: Icons.add, warna: Colors.blue,),
                      AdminWordsRequested(title: 'Requests (ADMIN)', icon: Icons.list, warna: Colors.red,),
                      /* MyMenu5(title: 'My Account', icon: Icons.account_circle, warna: Colors.blue,),
                    MyMenu6(title: 'Refer to a friend', icon: Icons.send, warna: Colors.blue,),*/
                    ],)
              );
            }
        ),
      ),
    );
  }
}


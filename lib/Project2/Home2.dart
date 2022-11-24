import 'package:appwithfirebase/screens/wrapper.dart';
import 'package:appwithfirebase/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/myuser.dart';
import '../screens/authenticate/authenticate.dart';
import '../services/auth.dart';
import '../shared/loading.dart';
import './menu.dart';
import '../services/class_vocab.dart';

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


class Home2 extends StatefulWidget {
  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2>{
  _Home2State({this.accountEmail = 'Hier könnte ihre Mailadresse stehen', this.accountName = 'MAX MUSTERMANN'});

  final String accountName;
  final String accountEmail;
  List<int> favoriteVocab = List<int>.empty(growable: true);
  //List<Vocab> vocabs = allVocabs2;
  final AuthService _auth = AuthService();


  @override
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget build(BuildContext context) {
    String? role = 'user';
    MyUser user = Provider.of<MyUser>(context);
    return StreamBuilder<DeewanUserData>(
      stream: DeewanDataBaseService(uid: user.uid).deewanUserData,
      builder: (context, snapshot) {
    if (snapshot.hasData) {
      DeewanUserData? deewanUserData = snapshot.data!;
      deewanUserData.role != null ? role = deewanUserData.role : null;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Menu'),
            backgroundColor: Colors.blue,
            actions: <Widget>[
              ElevatedButton.icon(
          style: ElevatedButton.styleFrom(primary: Colors.blue[300]),
                icon: const Icon(Icons.person),
                label: Text('Logout'),
                onPressed: () {
                  _signOut();
                  /*await _auth.signOut();*/
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Authenticate(),
                      ));*/
                  Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(
                          builder: (context) =>
                          new Wrapper()),
                          (route) => false);
                  /*Navigator.of(context, rootNavigator: true).pop(context);  */          },
              )
            ],
          ),
          backgroundColor: Colors.white,

          /*drawer: Drawer(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                    accountName: Text(accountName, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
                    accountEmail: Text(accountEmail),
                    currentAccountPicture: const CircleAvatar(
                      backgroundImage: NetworkImage("https://pic.onlinewebfonts.com/svg/img_335286.png"),
                    ),
                    decoration: const BoxDecoration(color: Colors.blue),
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
          ),*/

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
              builder: (context, snapshot)  {
                if(role=='admin'){
                  return Container(
                      padding: const EdgeInsets.all(30.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        children:
                        <Widget>[
                          MyMenu(title: 'Word Search', icon: Icons.search, warna: Colors.blue,/*vocabs: vocabs,*/ favoriteVocabs: favoriteVocab),
                          FavoriteVocabs(title: 'Favorites', icon: Icons.folder, warna: Colors.blue, /*vocabs: vocabs,*/ favoriteVocabs: favoriteVocab),
                          /*MyMenu3(title: 'Quiz', icon: Icons.quiz, warna: Colors.blue,),
                        */WordRequest(title: 'Word Request', icon: Icons.add, warna: Colors.blue,),
                          Quiz(title: 'Quiz', icon: Icons.quiz, warna: Colors.blue,),

                          AdminWordsRequested(title: 'Requests \n (ADMIN)', icon: Icons.list, warna: Colors.red,),
                          /* MyMenu5(title: 'My Account', icon: Icons.account_circle, warna: Colors.blue,),
                        MyMenu6(title: 'Refer to a friend', icon: Icons.send, warna: Colors.blue,),*/
                        ],)
                  );
                }else{return Container(
                    padding: const EdgeInsets.all(30.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      children:
                      <Widget>[
                        MyMenu(title: 'Word Search', icon: Icons.search, warna: Colors.blue,/*vocabs: vocabs,*/ favoriteVocabs: favoriteVocab),
                        FavoriteVocabs(title: 'Favorites', icon: Icons.folder, warna: Colors.blue, /*vocabs: vocabs,*/ favoriteVocabs: favoriteVocab),
                        /*MyMenu3(title: 'Quiz', icon: Icons.quiz, warna: Colors.blue,),
                        */WordRequest(title: 'Word Request', icon: Icons.add, warna: Colors.blue,),
                        Quiz(title: 'Quiz', icon: Icons.quiz, warna: Colors.blue,),
/*
                        AdminWordsRequested(title: 'Requests (ADMIN)', icon: Icons.list, warna: Colors.red,),
*/
                        /* MyMenu5(title: 'My Account', icon: Icons.account_circle, warna: Colors.blue,),
                        MyMenu6(title: 'Refer to a friend', icon: Icons.send, warna: Colors.blue,),*/
                      ],)
                );}
              }
            ),
          ),
        );
    } else {
      print('sind wir hier?');
      return Loading();
    }
      }

    );

  }
}




import 'package:appwithfirebase/Project2/Pages/learning_material.dart';
import 'package:appwithfirebase/Project2/Search/search.dart';
import 'package:appwithfirebase/Project2/Search/vocab.dart';
import 'package:appwithfirebase/models/myuser.dart';
import 'package:appwithfirebase/screens/home/home.dart';
import 'package:appwithfirebase/screens/home/vocab_screen.dart';
import 'package:appwithfirebase/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appwithfirebase/services/database.dart';

class FavoriteScreen extends StatefulWidget {
  final List<Vocab> vocabs;

  FavoriteScreen(
    this.vocabs,
  );

  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  Widget _buildList(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    return StreamBuilder<DeewanUserData>(
        stream: DeewanDataBaseService(uid: user.uid).deewanUserData,
        builder: (context, snapshot) {
          DeewanUserData? deewanUserData = snapshot.data!;
          print('name');
          print('name: $deewanUserData.name');
          if (snapshot.hasData) {
            DeewanUserData? deewanUserData = snapshot.data!;
            return ListView.builder(
              itemCount: deewanUserData.myFavoriteVocabs.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                final thisVocab = widget.vocabs
                    .where((element) =>
                        element.id == deewanUserData.myFavoriteVocabs[index])
                    .first;
                return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(thisVocab.englishMain),
                        Text(thisVocab.arabicMain)
                      ],
                    ),
                    trailing: IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () async {

                          List _withoutTheFavorite = List.from(deewanUserData.myFavoriteVocabs);
                          _withoutTheFavorite.remove(thisVocab.id);
                          await DeewanDataBaseService(uid: user.uid)
                              .updateDeewanUserFavorite(
                                  _withoutTheFavorite);
                        }),
                onTap:
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VocabScreen(thisVocab)),
                  );
                });
              },
            );
          } else {
            return Loading();
          }
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Favorite Words'),
        ),
        /*actions: <Widget>[
              IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
            ]),*/
        body: _buildList(context));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/myuser.dart';
import '../../screens/home/vocab_screen.dart';
import '../../services/database.dart';
import '../../shared/loading.dart';

class FavoriteScreenSubOld extends StatefulWidget {
  final List vocabs;

  const FavoriteScreenSubOld(this.vocabs, {Key? key}) : super(key: key);

  @override
  _FavoriteScreenSubOldState createState() => _FavoriteScreenSubOldState();
}

class _FavoriteScreenSubOldState extends State<FavoriteScreenSubOld> {
  Widget _buildList(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    return StreamBuilder<DeewanUserData>(
        stream: DeewanDataBaseService(uid: user.uid).deewanUserData,
        builder: (context, snapshot) {
          //DeewanUserData? deewanUserData = snapshot.data;
          //print('name');
          //print('name: $deewanUserData.name');
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
          title: const Text('Favorite Words'),
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
                  ColorFilter.mode(Colors.blue.withOpacity(0.1),
                      BlendMode.dstATop),)),

            child: _buildList(context)

        ));
  }
}

class ForgottenVocab extends StatefulWidget {
  final List vocabs;

  const ForgottenVocab(this.vocabs, {Key? key}) : super(key: key);

  @override
  _forgottenVocab createState() => _forgottenVocab();
}

class _forgottenVocab extends State<ForgottenVocab> {
  Widget _buildList(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    return StreamBuilder<DeewanUserData>(
        stream: DeewanDataBaseService(uid: user.uid).deewanUserData,
        builder: (context, snapshot) {
          //DeewanUserData? deewanUserData = snapshot.data;
          //print('name');
          //print('name: $deewanUserData.name');
          if (snapshot.hasData) {
            DeewanUserData? deewanUserData = snapshot.data!;
            return ListView.builder(
              itemCount: deewanUserData.forgottenVocab?.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                final thisVocab = widget.vocabs
                    .where((element) =>
                element.id == deewanUserData.forgottenVocab?[index])
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
                          List _withoutTheFavorite = List.from(deewanUserData.forgottenVocab!);
                          _withoutTheFavorite.remove(thisVocab.id);
                          await DeewanDataBaseService(uid: user.uid)
                              .updateForgottenVocab(
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
          title: const Text('forgotten Vocab'),
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
    ColorFilter.mode(Colors.blue.withOpacity(0.1),
    BlendMode.dstATop),)),

    child: _buildList(context)

    ));
  }
}

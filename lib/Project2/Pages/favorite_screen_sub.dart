import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/myuser.dart';
import '../../screens/home/vocab_screen.dart';
import '../../services/database.dart';
import '../../shared/loading.dart';

class FavoriteScreenSub extends StatefulWidget {
  final List vocabs;
  final SinglePersonalVocabList _SinglePersonalVocabList;

  const FavoriteScreenSub(this.vocabs, this._SinglePersonalVocabList, {Key? key}) : super(key: key);

  @override
  _FavoriteScreenSubState createState() => _FavoriteScreenSubState();
}

class _FavoriteScreenSubState extends State<FavoriteScreenSub> {
  Widget _buildList(BuildContext context) {
    return ListView.builder(
      itemCount: widget._SinglePersonalVocabList.personalVocabsList.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final thisVocab = widget.vocabs
                    .where((element) =>
                element.id == widget._SinglePersonalVocabList.personalVocabsList[index])
                    .first;
                return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(thisVocab.englishMain),
                        Text(thisVocab.arabicMain)
                      ],
                    ),
                    /*trailing: IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () async {
                          List _withoutTheFavorite = List.from(deewanUserData.myFavoriteVocabs);
                          _withoutTheFavorite.remove(thisVocab.id);
                          await DeewanDataBaseService(uid: user.uid)
                              .updateDeewanUserFavorite(
                              _withoutTheFavorite);
                        }),*/
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


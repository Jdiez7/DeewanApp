import 'package:appwithfirebase/Project2/Search/add_vocab.dart';
import 'package:appwithfirebase/Project2/Search/search.dart';
import 'package:appwithfirebase/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/myuser.dart';
import '../../screens/home/vocab_screen.dart';
import '../../services/database.dart';
import '../../shared/loading.dart';
import '../../services/class_vocab.dart';

class FavoriteScreenSub extends StatefulWidget {
  final List<Vocab> vocabs;
  final SinglePersonalVocabList _SinglePersonalVocabList;

  const FavoriteScreenSub(this.vocabs, this._SinglePersonalVocabList,
      {Key? key})
      : super(key: key);

  @override
  _FavoriteScreenSubState createState() => _FavoriteScreenSubState();
}

class _FavoriteScreenSubState extends State<FavoriteScreenSub> {
  Widget _buildList(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    return StreamBuilder<DeewanUserData>(
        stream: DeewanDataBaseService(uid: user.uid).deewanUserData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DeewanUserData? deewanUserData = snapshot.data!;
            return StreamBuilder<SinglePersonalVocabList>(
                stream: DeewanDataBaseService(
                        uid: user.uid,
                        docID: widget._SinglePersonalVocabList.docId)
                    .personalList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    SinglePersonalVocabList _singleList = snapshot.data!;

                    return ListView.builder(
                      itemCount: _singleList.personalVocabsList.length,
                      padding: const EdgeInsets.all(16.0),
                      itemBuilder: (context, index) {
                        final thisVocab = widget.vocabs
                            .where((element) =>
                                element.id ==
                                _singleList
                                    .personalVocabsList[index])
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
                                  List _withoutTheFavorite = List.from(_singleList
                                      .personalVocabsList);
                                  _withoutTheFavorite.remove(thisVocab.id);
                                  await DeewanDataBaseService(uid: user.uid)
                                      .updatePersonalVocabList(
                                          _withoutTheFavorite,
                                          _singleList.docId);
                                }),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VocabScreen(thisVocab)),
                              );
                            });
                      },
                    );
                  } else {
                    return Loading();
                  }
                });
          } else {
            return Loading();
          }
        });
  }

  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget._SinglePersonalVocabList.listName),
          actions: <Widget>[
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: appBarColor),
              icon: const Icon(Icons.add),
              label: Text('Add Vocab'),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddVocabScreen(widget.vocabs, widget._SinglePersonalVocabList.docId, user.uid!),
                ));
              },
            )
          ],
        ),
        body:
        Container(
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

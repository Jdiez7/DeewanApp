import 'package:appwithfirebase/Project2/Pages/favorite_screen_sub_old.dart';
import 'package:appwithfirebase/Project2/Pages/learning_material.dart';
import 'package:appwithfirebase/Project2/Search/search.dart';
import 'package:appwithfirebase/services/class_vocab.dart';
import 'package:appwithfirebase/models/myuser.dart';
import 'package:appwithfirebase/screens/home/home.dart';
import 'package:appwithfirebase/screens/home/vocab_screen.dart';
import 'package:appwithfirebase/shared/constants.dart';
import 'package:appwithfirebase/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appwithfirebase/services/database.dart';
import 'favorite_screen_sub.dart';

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

    return StreamBuilder<List<SinglePersonalVocabList>>(
        stream: DeewanDataBaseService(uid: user.uid).personalVocabData,
        initialData: [],
        builder: (context, snapshot) {
          String _query = '';
          if (snapshot.hasData) {
            List<SinglePersonalVocabList>? personalVocabList = snapshot.data;
            personalVocabList?.sort((a, b) {
             return a.listName.toLowerCase().compareTo(b.listName.toLowerCase());});
            personalVocabList?.sort((a, b) {
              if(b.fixed) {
                return 1;
              }
              return -1;
            });
            final int _Listlength;
            if (personalVocabList == null) {
              _Listlength = 3;
            } else {
              _Listlength = personalVocabList.length + 3;
            }

            return ListView.builder(
              itemCount: _Listlength,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                if (index == _Listlength - 1) {
                  return Container(
                    color: globalTileColor,
                  child: ListTile(
                      title: TextField(
                        onChanged: (text) {
                          _query = text;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Add New List',
                        ),
                      ),
                      leading: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            await DeewanDataBaseService(uid: user.uid)
                                .addNewFile(_query);
                          }),
                      onTap: () async {}));
                }
                if (index == 0) {
                  return Container(
                      color: globalTileColor,
                      child:  ListTile(
                      title: Text('Favorite List'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FavoriteScreenSubOld(widget.vocabs)),
                        );
                      }));
                }
                if (index == _Listlength - 2) {
                  return Container(
                    color: globalTileColor,
                    child: ListTile(
                      title: Text('forgotten Vocab'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ForgottenVocab(widget.vocabs)),
                        );
                      }));
                }

                return Container(
                    color: globalTileColor,
                    child:  ListTile(

                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(personalVocabList![index - 1].listName),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoriteScreenSub(
                                widget.vocabs, personalVocabList[index - 1])),
                      );
                    },
                trailing: personalVocabList[index - 1].fixed == false ?
                    IconButton(
                icon: Icon(Icons.remove),
                onPressed: () async {await DeewanDataBaseService(uid: user.uid)
                    .deleteFile(personalVocabList[index - 1].docId);
                }):null,));
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
                  ColorFilter.mode(Colors.black.withOpacity(0.4),
                      BlendMode.dstATop),)),

            child: _buildList(context)

            )
    );
  }
}

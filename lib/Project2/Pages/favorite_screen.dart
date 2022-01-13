import 'package:appwithfirebase/Project2/Search/search.dart';
import 'package:appwithfirebase/Project2/Search/vocab.dart';
import 'package:appwithfirebase/models/myuser.dart';
import 'package:appwithfirebase/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appwithfirebase/services/database.dart';



class FavoriteScreen extends StatefulWidget {
  final List<int> favoriteVocabs;
  final List<Vocab> vocabs;

  FavoriteScreen(this.vocabs, this.favoriteVocabs);

  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  Widget _buildList(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);

    return StreamBuilder<DeewanUserData>(
        stream: DeewanDataBaseService(uid: user.uid).deewanUserData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          DeewanUserData? deewanUserData = snapshot.data;
        return ListView.builder(
          itemCount: widget.favoriteVocabs.length,
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, index) {
            final thisVocab = widget.vocabs
                .where((element) => element.id == widget.favoriteVocabs[index])
                .first;
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(thisVocab.englishMain), Text(thisVocab.arabicMain)],
              ),
              trailing: IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => setState(() {
                  widget.favoriteVocabs.remove(thisVocab.id);
                }),
              ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VocabScreen(thisVocab)),
                  );}
            );
          },
        );}else{
          return Loading();
        }
      }
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green,
            title: const Text('Favorite Words'),),
            /*actions: <Widget>[
              IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
            ]),*/
        body: _buildList(context));
  }
}

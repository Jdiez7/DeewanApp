import 'package:appwithfirebase/From%20other%20git/vocablist.dart';
import 'package:appwithfirebase/services/class_vocab.dart';
import 'package:appwithfirebase/models/myuser.dart';
import 'package:appwithfirebase/services/auth.dart';
import 'package:appwithfirebase/services/database.dart';
import 'package:appwithfirebase/shared/loading.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class Home3 extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    print('user ====> ${user.uid}');

    return StreamProvider<List<Vocab>>.value(
      value: DeewanDataBaseService().backendVocabs,
      initialData: [],
      child: Scaffold(
        backgroundColor: Colors.blue[800],
        appBar: AppBar(
          title: Text('Vocaby'),
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Loading(),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
        body: VocabList(),
      ),
    );
  }
}
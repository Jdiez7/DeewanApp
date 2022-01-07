import 'package:appwithfirebase/models/deewani.dart';
import 'package:appwithfirebase/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:appwithfirebase/services/database.dart';
import 'package:provider/provider.dart';
import 'package:appwithfirebase/screens/home/deewan_list.dart';
import 'package:appwithfirebase/models/deewani.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Deewani>>.value(
      value: DataBaseService().deewans,
      initialData: [],
      child: Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: const Text('In App'),
          backgroundColor: Colors.green[400],
          elevation: 0.0,
          actions: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: Text('Logout'),
              onPressed: () async{
                await _auth.signOut();
              },
            )
          ],
        ),
        body: DeewanList(
        ),
      ),
    );
  }
}

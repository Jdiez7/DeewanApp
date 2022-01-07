import 'package:appwithfirebase/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:appwithfirebase/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appwithfirebase/screens/home/deewan_list.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      value: DataBaseService().deewans,
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
        body: BrewList(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:appwithfirebase/models/deewani_deewanuser.dart';

class DeewaniTile extends StatelessWidget {

  final Deewani deewani;
  DeewaniTile({required this.deewani});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.green[deewani.strength],
          ),
          title: Text(deewani.name),
          subtitle: Text('Saved vocabs: ${deewani.sugars}'),
        ),
      ),
    );
  }
}

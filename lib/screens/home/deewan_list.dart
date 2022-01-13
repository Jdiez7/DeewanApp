import 'package:appwithfirebase/models/deewani_deewanuser.dart';
import 'package:appwithfirebase/screens/home/deewan_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeewanList extends StatefulWidget {
  const DeewanList({Key? key}) : super(key: key);

  @override
  _DeewanListState createState() => _DeewanListState();
}

class _DeewanListState extends State<DeewanList> {
  @override
  Widget build(BuildContext context) {

    final deewans = Provider.of<List<Deewani>>(context);
    deewans.forEach((deewani) {
      print(deewani.name);
      print(deewani.sugars);
      print(deewani.strength);
    });



    return ListView.builder(
      itemCount: deewans.length,
      itemBuilder: (context, index) {
        return DeewaniTile(deewani: deewans[index]);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class DeewanList extends StatefulWidget {
  const DeewanList({Key? key}) : super(key: key);

  @override
  _DeewanListState createState() => _DeewanListState();
}

class _DeewanListState extends State<DeewanList> {
  @override
  Widget build(BuildContext context) {

    final deewans = Provider.of<QuerySnapshot>(context);
    //print(deewans.docs);
    for (var doc in deewans.docs){
      print(doc.data());
    }

    return Container(

    );
  }
}

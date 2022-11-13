import 'package:appwithfirebase/From%20other%20git/Home3.dart';
import 'package:appwithfirebase/Project2/Home2.dart';
import 'package:appwithfirebase/models/myuser.dart';
import 'package:appwithfirebase/screens/authenticate/authenticate.dart';
import 'package:appwithfirebase/screens/home/home.dart';
import 'package:appwithfirebase/screens/splashscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper2 extends StatefulWidget {
  const Wrapper2({Key? key}) : super(key: key);

  @override
  _Wrapper2State createState() => _Wrapper2State();
}

class _Wrapper2State extends State<Wrapper2> {
  @override
  build(BuildContext context) {

    final user = Provider.of<MyUser?>(context);
/*
    final DocumentSnapshot snap = FirebaseFirestore.instance.collection('deewanUsers').doc(user?.uid).get();
*/


    // return either Home or Authenticate
    if (user == null){
      return Authenticate()  ;
    } else {
      return Home2();
    }
  }
}


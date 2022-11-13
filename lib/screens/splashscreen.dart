import 'package:appwithfirebase/screens/home/home.dart';
import 'package:appwithfirebase/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Project2/Home2.dart';
import '../Project2/Pages/learning_material.dart';
import 'home/admin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String role = 'user';
  
  @override
  
  void initState(){
    super.initState();
    _checkRole();

  }

  void _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('deewanUsers').doc(user?.uid).get();
    setState(() {
      role = snap['role'];
    });
    if(role=='user'){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home2()),
      );
     /* return Home2();*/
/*
      navigateNext(Home2());
*/
    } else if(role == 'admin'){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminScreen()),
      );
      /*return AdminScreen();*/
/*
      navigateNext(AdminScreen());
*/
    } else{
      print('no Role');
/*
      navigateNext(Home2());
*/

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home2()),
      );
    }
  }
  
  void navigateNext(Widget route){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => route));
  }
  
  
  Widget build(BuildContext context) {
    return learning_material();
    /*Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('welcome'),
          ],
        ),
      )
    );*/
  }
}

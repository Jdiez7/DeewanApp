import 'package:appwithfirebase/From%20other%20git/Home3.dart';
import 'package:appwithfirebase/Project2/Home2.dart';
import 'package:appwithfirebase/models/myuser.dart';
import 'package:appwithfirebase/screens/authenticate/authenticate.dart';
import 'package:appwithfirebase/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<MyUser?>(context);

    // return either Home or Authenticate
    if (user == null){
      return Authenticate();
    } else {
      return Home2();
    }
      }
}

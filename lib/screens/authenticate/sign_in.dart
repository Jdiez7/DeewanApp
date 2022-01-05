import 'package:appwithfirebase/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Deewan'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: ElevatedButton(
          child:Text('Sign in Anon'),
          onPressed: () async {
            dynamic result = await _auth.signinAnon();
            if (result == null){
              print('error signing in');
            } else {
              print('signed in');
              print(result);
              print(result.uid);
            }
          },
        ),
      )
    );
  }
}

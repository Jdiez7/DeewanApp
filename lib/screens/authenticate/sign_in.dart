import 'package:appwithfirebase/services/auth.dart';
import 'package:appwithfirebase/shared/constants.dart';
import 'package:appwithfirebase/shared/loading.dart';
import 'package:flutter/material.dart';
import '';

class SignIn extends StatefulWidget {


  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;


  // Text field state

  String email = "";
  String password = "";
  String error = '';


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :  Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Sign in to Deewan'),
          actions: <Widget>[
            TextButton.icon(
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                label: const Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  widget.toggleView();
                })
          ],
        ),
        body:
    Container(
    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
    constraints: BoxConstraints.expand(),
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage("assets/app_bg5.jpg"),
    fit: BoxFit.cover,
    colorFilter:
    ColorFilter.mode(Colors.white.withOpacity(backgroundOpacity),
    BlendMode.dstATop),)),

    child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val!.isEmpty ? 'Enter an E-Mail' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (val) => val!.length < 6 ? 'Enter an password over 6 characters long' : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text(
                    'sign in',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                     if (_formKey.currentState!.validate()) {
                       setState(() => loading = true);
                       dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                        if (result == null) {

                          setState(() {
                            error = 'could not sign in with those credentials';
                            loading = false;
                          });
                        }
                  }
                  }


                ),

                SizedBox(height: 12.0,),
                Text(
                  error,
                  style: TextStyle(color: Colors.green, fontSize: 14.0),
                )
              ],
            ),
          ),
        ));
  }
}

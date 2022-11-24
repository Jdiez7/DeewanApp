import 'package:appwithfirebase/services/auth.dart';
import 'package:appwithfirebase/shared/constants.dart';
import 'package:appwithfirebase/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String name = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          title: Text('Register here'),
          actions: <Widget>[
            TextButton.icon(
                icon: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                label: const Text(
                  'Sign in',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  widget.toggleView();
                })
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),

                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val!.isEmpty ? 'Enter an E-Mail' : null,
                  onChanged: (val){
                    setState(() => email = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (val) => val!.length < 6 ? 'Enter an password over 6 characters long' : null,
                  obscureText: true,
                  onChanged: (val){
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Name'),
                  validator: (val) => val!.isEmpty ? 'Enter your Name' : null,
                  onChanged: (val){
                    setState(() => name = val);
                  },),SizedBox(height: 20.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.pink),
                  child: Text('Register',
                    style: TextStyle(color: Colors.white),),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.registerWithEmailAndPassword(
                          email, password, name);
                      if (result == null) {
                        setState(() {
                          error = 'pleas supply a valid email';
                          loading = false;
                        } );
                      }
                    }
                  }
                ),
                SizedBox(height: 12.0,),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ],
            ),
          ),
        )
    );  }
}

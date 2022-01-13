import 'package:appwithfirebase/models/myuser.dart';
import 'package:appwithfirebase/screens/home/home.dart';
import 'package:appwithfirebase/services/database.dart';
import 'package:appwithfirebase/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appwithfirebase/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  //form values
  String _currentName = '';
  String _currentSugars = '0';
  int _currentStrength = 100;

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    return StreamBuilder<UserData>(
      stream: DataBaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData? userData = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Update Settings',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                 initialValue: userData?.name,
                  decoration: textInputDecoration,
                  validator: (val) => val!.isEmpty ? 'Pelase enter a name' : null,
                  onChanged: (val) => setState(() {
                    _currentName = val;
                  }),
                ),
                SizedBox(height: 20.0,),
                DropdownButtonFormField(
                  value: _currentSugars ==''? userData?.sugars : userData?.sugars,
                  items: sugars.map((sugar){
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text('$sugar sugars'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() {
                    _currentSugars = val as String;
                  }),),
                Slider(
                    min: 100.0,
                    max: 900.0,
                    activeColor: Colors.brown[_currentStrength],
                    inactiveColor: Colors.brown,
                    divisions: 8,
                   value: (_currentStrength).toDouble(),
                    onChanged: (val) => setState(() {
                      _currentStrength = val.round();
                    })),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.pink),
                    child: Text('Update', style: TextStyle(color: Colors.white),),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        await DataBaseService(uid: user.uid).updateUserData(
                            _currentSugars,
                            _currentName,
                            _currentStrength);
                        Navigator.pop(context);
                      }

                    })
              ],
            ),
          );
        }else{
          return Loading();
        }
      }
    );
  }
}

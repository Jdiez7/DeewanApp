import 'package:flutter/material.dart';
import 'package:appwithfirebase/shared/constants.dart';

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
            decoration: textInputDecoration,
            validator: (val) => val!.isEmpty ? 'Pelase enter a name' : null,
            onChanged: (val) => setState(() {
              _currentName = val;
            }),
          ),
          SizedBox(height: 20.0,),
          DropdownButtonFormField(
            value: _currentSugars ==''? sugars[0] : sugars[0],
              items: sugars.map((sugar){
                return DropdownMenuItem(
                    value: sugar,
                    child: Text('$sugar sugars'),
                );
              }).toList(),
            onChanged: (val) => setState(() {
              _currentSugars = val as String;
            }),),
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.pink),
              child: Text('Update', style: TextStyle(color: Colors.white),),
              onPressed: () async {
                print(_currentName);
                print(_currentStrength);
                print(_currentSugars);
              })
        ],
      ),
    );
  }
}
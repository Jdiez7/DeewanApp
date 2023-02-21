import 'package:appwithfirebase/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/myuser.dart';
import 'requestedword_screen.dart';
import '../../services/database.dart';
import '../../shared/loading.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final requestWordKey = GlobalKey<ScaffoldState>();

  TextEditingController _englishWord = TextEditingController();
  TextEditingController _arabicWord = TextEditingController();
  TextEditingController _notes = TextEditingController();

  @override
  Widget _buildNewRequest(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    return ListView(children: <Widget>[
      SizedBox(
        height: 40,
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
            child: Column(children: <Widget>[
              TextFormField(
                controller: _englishWord,
                decoration: InputDecoration(
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(3.0),
                    width: 5,
                    height: 5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color:globalColor2)),
                    child: FittedBox(
                      child: Text('EN'),
                    ),
                  ),
                  hintText: "English Word",
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: _arabicWord,
                decoration: InputDecoration(
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(1.0),
                    width: 5,
                    height: 5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: globalColor2)),
                    child: FittedBox(
                      child: Text('عربي'),
                    ),
                  ),
                  hintText: "Arabic Word",
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: _notes,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.notes),
                  hintText: "Further Notes",
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: globalColor2,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Request New Word",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: ()
                    async {
                      if(_englishWord.text != "" || _arabicWord.text != ""){
                      await DeewanDataBaseService(uid: user.uid)
                          .newRequest(_englishWord, _arabicWord, _notes);}
                      else {}
                    },
                  ),
                ],
              ),
            ]),
        ),
      )
    ]);
  }

  Widget _buildList(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    return StreamBuilder<List<Request>>(
        stream: DeewanDataBaseService(uid: user.uid).requests,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Request>? requestList = snapshot.data;
            List<Request>? _MyRequests = null;
            _MyRequests = requestList?.where((i) => i.uid == user.uid).toList();
            print(_MyRequests);
            final int _Listlength;
            if (_MyRequests == null) {
              _Listlength = 1;
            } else {
              _Listlength = _MyRequests.length + 1;
            }
            print(_MyRequests?.length);
            return ListView.builder(
              itemCount: _Listlength,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(title: Text('Current Requests',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25,
                  fontWeight: FontWeight.bold)));
                }
                final thisRequest = _MyRequests![index-1];

                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text(
                        thisRequest.engReq,
                        overflow: TextOverflow.ellipsis,
                      )),
                      Flexible(
                        child: Text(
                        thisRequest.araReq,
                        overflow: TextOverflow.ellipsis,
                      )
                      )],
                  ),
                  trailing: thisRequest.uid == user.uid ? IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () async {
                         await DeewanDataBaseService(uid: user.uid)
                            .deleteRequest(thisRequest.reference);
                      }): null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => requestedwordScreen(thisRequest),
                    ));
                  },
                );
              },
            );
          } else {
            return Loading();
          }
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Requests'),
        ),
        /*actions: <Widget>[
              IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
            ]),*/
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/app_bg5.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.blue.withOpacity(0.1), BlendMode.dstATop),
          )),
          child: Column(
            children: [
              Flexible(
                child: Container(child: _buildNewRequest(context)),
              ),
              Flexible(
                child: Container(child: _buildList(context)),
              ),
            ],
          ),
        ));
  }
}

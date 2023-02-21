import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/myuser.dart';
import 'requestedword_screen.dart';
import '../../services/database.dart';
import '../../shared/loading.dart';

class AdminRequestedScreen extends StatefulWidget {
  @override
  _AdminRequestedScreenState createState() => _AdminRequestedScreenState();
}

class _AdminRequestedScreenState extends State<AdminRequestedScreen> {
  final requestWordKey = GlobalKey<ScaffoldState>();

  TextEditingController _englishWord = TextEditingController();
  TextEditingController _arabicWord = TextEditingController();
  TextEditingController _notes = TextEditingController();

  @override

  Widget _buildList(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);

    return StreamBuilder<List<Request>>(
        stream: DeewanDataBaseService(uid: user.uid).requests,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Request>? requestList = snapshot.data;
            final int _Listlength;
            if (requestList == null) {
              _Listlength = 0;
            } else {
              _Listlength = requestList.length + 0;
            }

            return ListView.builder(
              itemCount: _Listlength,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                final thisRequest = requestList![index];
                if (index == 0) {
                  return ListTile(title: Text('Current Requests',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25,
                          fontWeight: FontWeight.bold)));
                }
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
                  trailing: IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () async {
                        await DeewanDataBaseService(uid: user.uid)
                            .deleteRequest(thisRequest.reference);
                      }),
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
          backgroundColor: Colors.red,
          title: const Text('Admin Page: Requested Words'),
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
                child: Container(child: _buildList(context)),
              ),
            ],
          ),
        ));
  }
}
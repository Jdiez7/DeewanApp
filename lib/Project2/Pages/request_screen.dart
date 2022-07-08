import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/myuser.dart';
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
    return ListView(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Column(
                children: <Widget>[
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
                          border: Border.all(color: Colors.black)
                        ),
                        child: FittedBox(
                          child: Text('EN'
                          ),
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
                            border: Border.all(color: Colors.black)
                        ),
                        child: FittedBox(
                          child: Text('عربي'
                          ),
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
                    children: [ElevatedButton(
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
                    onPressed: () async {
                      await DeewanDataBaseService(uid: user.uid)
                          .newRequest(_englishWord,_arabicWord, _notes);
                      }
                    ,
                  ),
                ],
              ),
            ]),
          ),
          )]);



  }
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
              _Listlength = requestList.length+1;
            }

            return ListView.builder(
              itemCount: _Listlength,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                      title: Text(requestList.toString()));
                }
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(requestList![index].engReq+ 'HIIIII'),
                    ],
                  ),/*
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ,
                    );
                  },*/
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
          backgroundColor: Colors.blue,
          title: const Text('Request New Word'),
        ),
        /*actions: <Widget>[
              IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
            ]),*/
        body:

        Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/app_bg.jpg"),
        fit: BoxFit.cover,
        colorFilter:
        ColorFilter.mode(Colors.black.withOpacity(0.1),
        BlendMode.dstATop),)),

        child:
        Column(
          children: [
            Flexible(
              child: Container(
                child: _buildNewRequest(context)
              ),
            ),
            Flexible(
              child: Container(
                child: _buildList(context)
              ),
            ),
          ],
        ),
    ));
  }
}



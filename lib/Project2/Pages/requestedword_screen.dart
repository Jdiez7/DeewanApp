import 'package:appwithfirebase/models/myuser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class requestedwordScreen extends StatefulWidget {
  final Request request;

  const requestedwordScreen(this.request, {Key? key}) : super(key: key);

  @override
  _requestedwordScreenState createState() => _requestedwordScreenState();
}

class _requestedwordScreenState extends State<requestedwordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request"),
      ),
      body: Container(constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/app_bg5.jpg"),
              fit: BoxFit.cover,
              colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.4),
                  BlendMode.dstATop),)),

        child: ListView(
          children: [
            const Placeholder(5),
            ThisRequest(widget.request),
            const Placeholder(5),
            Comment(widget.request),
          ],
        ),
      ),
    );
  }

}

class Placeholder extends StatelessWidget {
  final double pxl;

  const Placeholder(this.pxl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        height: pxl,
      ),
    );
  }
}

class ThisRequest extends StatelessWidget {
  final Request request;
  const ThisRequest(this.request, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          /*height: 60,*/
          color: Colors.blue[100],
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    " \n",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,

                  ),
                  Text(
                    "Eng                  Ara",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,

                  ),
                  Text(
                    "",
                    style: TextStyle(fontSize: 20),
                    overflow: TextOverflow.ellipsis,

                  )
                ],
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Flexible(child:
              Text(
                request.engReq,
                style: TextStyle(fontSize: 20/*, fontWeight: FontWeight.bold*/),
              )),
              Flexible(child:
                  Text(
                request.araReq + "\t \t ",
                style: TextStyle(fontSize: 20),
              )
              )],
          ),
            Placeholder(10)]),
        ));
  }
}

class Comment extends StatelessWidget {
  final Request request;

  const Comment(this.request, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          /*height: 60,*/
          color: Colors.blue[100],
          child: Column(
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    " \n",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,

                  ),
                  Text(
                    "Comment",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,

                  ),
                  Text(
                    "",
                    style: TextStyle(fontSize: 20),
                    overflow: TextOverflow.ellipsis,

                  )
                ],
              ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(child:Text(
                request.notesReq,
                style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.justify
              ))
            ],
          ),
        ])),
    );
  }
}
import 'package:appwithfirebase/Project2/Search/vocab.dart';
import 'package:appwithfirebase/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class VocabTile extends StatelessWidget {
  final Vocab vocab;
  VocabTile({required this.vocab});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      // actionExtentRatio: 0.25,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[300],
        ),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        // color: Colors.transparent,
        child: ListTile(
          title: Text(vocab.englishMain),
          subtitle: Text(vocab.arabicMain),
        ),
      ),
      secondaryActions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: IconSlideAction(
            caption: 'Edit',
            color: Colors.green[400],
            icon: Icons.mode_edit,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Loading(),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => Loading(),
          ),
        ),
      ],
    );
  }
}
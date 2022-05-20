import 'package:appwithfirebase/From%20other%20git/vocab_tile.dart';
import 'package:appwithfirebase/services/class_vocab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VocabList extends StatefulWidget {
  @override
  _VocabListState createState() => _VocabListState();
}

class _VocabListState extends State<VocabList> {
  @override
  Widget build(BuildContext context) {
    final vocabs = Provider.of<List<Vocab>>(context);

    print('vocabs length ======= ${vocabs.length}');

    return ListView.builder(
        itemCount: vocabs.length,
        itemBuilder: (context, index) {
          return VocabTile(vocab: vocabs[index]);
        });
  }
}
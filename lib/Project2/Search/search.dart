import 'package:appwithfirebase/Project2/Search/allvocabs.dart';
import 'package:appwithfirebase/Project2/Search/search_widget.dart';
import 'package:appwithfirebase/Project2/Search/vocab.dart';
import 'package:flutter/material.dart';

class SearchWordScreen extends StatefulWidget {
  final List<Vocab> vocabs;
  final List<int> favoriteVocabs;

  SearchWordScreen(this.vocabs, this.favoriteVocabs);

  @override
  SearchWordScreenState createState() => SearchWordScreenState();
}

class SearchWordScreenState extends State<SearchWordScreen> {
  String query = '';
  late List<Vocab> vocabs;

  @override
  void initState() {
    super.initState();
    vocabs = widget.vocabs;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('SEARCH'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            buildSearch(),
            Expanded(
              child: ListView.builder(
                itemCount: vocabs.length,
                itemBuilder: (context, index) {
                  final vocab = vocabs[index];

                  return buildVocab(vocab);
                },
              ),
            ),
          ],
        ),
      );

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search Word',
        onChanged: searchVocab,
      );

  Widget buildVocab(Vocab vocab) => ListTile(
        //leading: Text(vocab.englishMain),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(vocab.englishMain), Text(vocab.arabicMain)],
        ),
        trailing: IconButton(
          icon: Icon(widget.favoriteVocabs.contains(vocab.id)
              ? Icons.favorite
              : Icons.favorite_border,color: Colors.red, ),
          onPressed: () => setState(() {
            if(widget.favoriteVocabs.contains(vocab.id)){
              widget.favoriteVocabs.remove(vocab.id);
            } else {
              widget.favoriteVocabs.add(vocab.id);
            }
          }),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VocabScreen(vocab)),
          );}


          /*Navigator.pushNamed(context, VocabScreen.routeName,
              arguments: ScreenArguments(vocab));
        },*/
      );

  void searchVocab(String query) {
    final vocabs = allVocabs.where((vocab) {
      final titleLower = vocab.englishMain.toLowerCase();
      final authorLower = vocab.arabicMain.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          authorLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.vocabs = vocabs;
    });
  }
}


class VocabScreen extends StatelessWidget {

  final Vocab vocab;
  VocabScreen(this.vocab, {Key? key}) : super(key: key);
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute
    // settings and cast them as ScreenArguments.
    return Scaffold(
      appBar: AppBar(
        title: Text(vocab.englishMain + '  -  ' + vocab.arabicMain),
      ),
      body: Center(
        child: Text(vocab.exampleSentence),
      ),
    );
  }
}

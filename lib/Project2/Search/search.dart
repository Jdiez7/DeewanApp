import 'package:appwithfirebase/Project2/Search/Xallvocabs.dart';
import 'package:appwithfirebase/Project2/Search/search_widget.dart';
import 'package:appwithfirebase/services/class_vocab.dart';
import 'package:appwithfirebase/Project2/menu.dart';
import 'package:appwithfirebase/models/myuser.dart';
import 'package:appwithfirebase/screens/home/vocab_screen.dart';
import 'package:appwithfirebase/screens/wrapper.dart';
import 'package:appwithfirebase/services/database.dart';
import 'package:appwithfirebase/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchWordScreen extends StatefulWidget {
  final List<Vocab> vocabs;
  final List favoriteVocabs;

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
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    return StreamBuilder<DeewanUserData>(
        stream: DeewanDataBaseService(uid: user.uid).deewanUserData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DeewanUserData deewanUserData = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: Text('SEARCH'),
                centerTitle: true,
              ),
              body: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/app_bg5.jpg"),
                      fit: BoxFit.cover,
                      colorFilter:
                      ColorFilter.mode(Colors.black.withOpacity(0.1),
                          BlendMode.dstATop),)),

                child: Column(
                  children: <Widget>[
                    buildSearch(),
                    Expanded(
                      child: ListView.builder(
                          itemCount: vocabs.length,
                          itemBuilder: (context, index) {
                            vocabs.sort((a, b) => a.englishMain.toLowerCase().compareTo(b.englishMain.toLowerCase()));
                            final vocab = vocabs[index];
                            return buildVocab(vocab, deewanUserData);
                          },
                        ),
                      ),

                  ],
                ),
              ),
            );
          } else {
            return Wrapper();
          }
        });
  }
  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Search Word',
    onChanged: searchVocab,
  );
  /*Widget buildSearch() => Consumer<HoldVocab>(
    builder: (context, holdVocab, _) {
      vocabs = holdVocab.allVocabs;
      //searchVocab(query);
      return SearchWidget(
            text: query,
            hintText: 'Search Word',
            onChanged: searchVocab,
          );
    }
  );
*/
  Widget buildVocab(Vocab vocab, DeewanUserData deewanUserData) => ListTile(
      //leading: Text(vocab.englishMain),
  title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Flexible(child:Text(vocab.englishMain,overflow: TextOverflow.ellipsis,)), Text(vocab.arabicMain,overflow: TextOverflow.ellipsis,)],
      ),
      trailing: IconButton(
        icon: Icon(
          deewanUserData.myFavoriteVocabs.contains(vocab.id)
              ? Icons.favorite
              : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () =>

            setState(()  {
          List _withoutTheFavorite = List.from(deewanUserData.myFavoriteVocabs);
          if (deewanUserData.myFavoriteVocabs.contains(vocab.id))  {
              _withoutTheFavorite.remove(vocab.id);
              DeewanDataBaseService(uid: deewanUserData.uid)
                  .updateDeewanUserFavorite(
                  _withoutTheFavorite);
            }
           else {
            _withoutTheFavorite.add(vocab.id);
            DeewanDataBaseService(uid: deewanUserData.uid)
                .updateDeewanUserFavorite(
                _withoutTheFavorite);
          }
        }),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VocabScreen(vocab)),
        );
      }

      /*Navigator.pushNamed(context, VocabScreen.routeName,
              arguments: ScreenArguments(vocab));
        },*/
      );

  void searchVocab(String query) {
    final vocabs = widget.vocabs.where((vocab) {
      final englishMain = vocab.englishMain.toLowerCase();
      final arabicMain = normalise(vocab.arabicMain.toLowerCase());
      final nounPluralLower = vocab.nOUNplural.toLowerCase();
      final verbLower = vocab.verb.toLowerCase();
      final adjLower = vocab.adjective.toLowerCase();
      final verbengLower = vocab.verbEng.toLowerCase();
      final adjengLower = vocab.adjectiveEng.toLowerCase();
      final nomVerbLower = vocab.nomVerbAra.toLowerCase();
      final nomengLower = vocab.nomVerbEng.toLowerCase();
      final masLower = vocab.masder.toLowerCase();
      final masengLower = vocab.masderENG.toLowerCase();

      final searchLower = normalise(query.toLowerCase());

      return englishMain.contains(searchLower) ||
          arabicMain.contains(searchLower)||
          nounPluralLower.contains(searchLower)||
          verbLower.contains(searchLower)||
          adjLower.contains(searchLower)||
          verbengLower.contains(searchLower)||
          adjengLower.contains(searchLower)||
          nomVerbLower.contains(searchLower)||
          nomengLower.contains(searchLower)||
          masLower.contains(searchLower)||
          masengLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.vocabs = vocabs;
    });
  }
}

normalise(input) => input
    .replaceAll('\u0610', '') //ARABIC SIGN SALLALLAHOU ALAYHE WA SALLAM
    .replaceAll('\u0611', '') //ARABIC SIGN ALAYHE ASSALLAM
    .replaceAll('\u0612', '') //ARABIC SIGN RAHMATULLAH ALAYHE
    .replaceAll('\u0613', '') //ARABIC SIGN RADI ALLAHOU ANHU
    .replaceAll('\u0614', '') //ARABIC SIGN TAKHALLUS

    //Remove koranic anotation
    .replaceAll('\u0615', '') //ARABIC SMALL HIGH TAH
    .replaceAll(
    '\u0616', '') //ARABIC SMALL HIGH LIGATURE ALEF WITH LAM WITH YEH
    .replaceAll('\u0617', '') //ARABIC SMALL HIGH ZAIN
    .replaceAll('\u0618', '') //ARABIC SMALL FATHA
    .replaceAll('\u0619', '') //ARABIC SMALL DAMMA
    .replaceAll('\u061A', '') //ARABIC SMALL KASRA
    .replaceAll('\u06D6',
    '') //ARABIC SMALL HIGH LIGATURE SAD WITH LAM WITH ALEF MAKSURA
    .replaceAll('\u06D7',
    '') //ARABIC SMALL HIGH LIGATURE QAF WITH LAM WITH ALEF MAKSURA
    .replaceAll('\u06D8', '') //ARABIC SMALL HIGH MEEM INITIAL FORM
    .replaceAll('\u06D9', '') //ARABIC SMALL HIGH LAM ALEF
    .replaceAll('\u06DA', '') //ARABIC SMALL HIGH JEEM
    .replaceAll('\u06DB', '') //ARABIC SMALL HIGH THREE DOTS
    .replaceAll('\u06DC', '') //ARABIC SMALL HIGH SEEN
    .replaceAll('\u06DD', '') //ARABIC END OF AYAH
    .replaceAll('\u06DE', '') //ARABIC START OF RUB EL HIZB
    .replaceAll('\u06DF', '') //ARABIC SMALL HIGH ROUNDED ZERO
    .replaceAll('\u06E0', '') //ARABIC SMALL HIGH UPRIGHT RECTANGULAR ZERO
    .replaceAll('\u06E1', '') //ARABIC SMALL HIGH DOTLESS HEAD OF KHAH
    .replaceAll('\u06E2', '') //ARABIC SMALL HIGH MEEM ISOLATED FORM
    .replaceAll('\u06E3', '') //ARABIC SMALL LOW SEEN
    .replaceAll('\u06E4', '') //ARABIC SMALL HIGH MADDA
    .replaceAll('\u06E5', '') //ARABIC SMALL WAW
    .replaceAll('\u06E6', '') //ARABIC SMALL YEH
    .replaceAll('\u06E7', '') //ARABIC SMALL HIGH YEH
    .replaceAll('\u06E8', '') //ARABIC SMALL HIGH NOON
    .replaceAll('\u06E9', '') //ARABIC PLACE OF SAJDAH
    .replaceAll('\u06EA', '') //ARABIC EMPTY CENTRE LOW STOP
    .replaceAll('\u06EB', '') //ARABIC EMPTY CENTRE HIGH STOP
    .replaceAll('\u06EC', '') //ARABIC ROUNDED HIGH STOP WITH FILLED CENTRE
    .replaceAll('\u06ED', '') //ARABIC SMALL LOW MEEM

    //Remove tatweel
    .replaceAll('\u0640', '')

    //Remove tashkeel
    .replaceAll('\u064B', '') //ARABIC FATHATAN
    .replaceAll('\u064C', '') //ARABIC DAMMATAN
    .replaceAll('\u064D', '') //ARABIC KASRATAN
    .replaceAll('\u064E', '') //ARABIC FATHA
    .replaceAll('\u064F', '') //ARABIC DAMMA
    .replaceAll('\u0650', '') //ARABIC KASRA
    .replaceAll('\u0651', '') //ARABIC SHADDA
    .replaceAll('\u0652', '') //ARABIC SUKUN
    .replaceAll('\u0653', '') //ARABIC MADDAH ABOVE
    .replaceAll('\u0654', '') //ARABIC HAMZA ABOVE
    .replaceAll('\u0655', '') //ARABIC HAMZA BELOW
    .replaceAll('\u0656', '') //ARABIC SUBSCRIPT ALEF
    .replaceAll('\u0657', '') //ARABIC INVERTED DAMMA
    .replaceAll('\u0658', '') //ARABIC MARK NOON GHUNNA
    .replaceAll('\u0659', '') //ARABIC ZWARAKAY
    .replaceAll('\u065A', '') //ARABIC VOWEL SIGN SMALL V ABOVE
    .replaceAll('\u065B', '') //ARABIC VOWEL SIGN INVERTED SMALL V ABOVE
    .replaceAll('\u065C', '') //ARABIC VOWEL SIGN DOT BELOW
    .replaceAll('\u065D', '') //ARABIC REVERSED DAMMA
    .replaceAll('\u065E', '') //ARABIC FATHA WITH TWO DOTS
    .replaceAll('\u065F', '') //ARABIC WAVY HAMZA BELOW
    .replaceAll('\u0670', '') //ARABIC LETTER SUPERSCRIPT ALEF

    //Replace Waw Hamza Above by Waw
    .replaceAll('\u0624', '\u0648')

    //Replace Ta Marbuta by Ha
    .replaceAll('\u0629', '\u0647')

    //Replace Ya
    // and Ya Hamza Above by Alif Maksura
    .replaceAll('\u064A', '\u0649')
    .replaceAll('\u0626', '\u0649')

    // Replace Alifs with Hamza Above/Below
    // and with Madda Above by Alif
    .replaceAll('\u0622', '\u0627')
    .replaceAll('\u0623', '\u0627')
    .replaceAll('\u0625', '\u0627');

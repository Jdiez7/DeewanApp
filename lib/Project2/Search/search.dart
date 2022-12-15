import 'dart:math';

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
                            vocabs.sort((a, b) => value(a, query).compareTo(value(b, query)));

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

  value(Vocab vocab, String query){
    var len = query.length;
    var len1 = min(vocab.englishMain.length, len);
    var len2 = min(vocab.english2.length, len);
    var len3 = min(vocab.english3.length, len);
    var len4 = min(vocab.english4.length, len);
    var len5 = min(vocab.englishMain.length, len+3);
    var len6 = min(vocab.english2.length, len+3);
    var len7 = min(vocab.english3.length, len+3);
    var len8 = min(vocab.english4.length, len+3);
    int val = 0;
    if( vocab.englishMain.substring(0,len1).toLowerCase().contains(query.toLowerCase())  ||
        vocab.english2.substring(0,len2).toLowerCase().contains(query.toLowerCase()) ||
        vocab.english3.substring(0,len3).toLowerCase().contains(query.toLowerCase()) ||
        vocab.english4.substring(0,len4).toLowerCase().contains(query.toLowerCase()) ||
        vocab.englishMain.substring(min(3,vocab.englishMain.length),len5).toLowerCase().contains(query.toLowerCase()) && vocab.englishMain.substring(0,min(3,vocab.englishMain.length)).toLowerCase() == "to "||
        vocab.english2.substring(min(3,vocab.english2.length),len6).toLowerCase().contains(query.toLowerCase()) && vocab.englishMain.substring(0,min(3,vocab.english2.length)).toLowerCase() == "to "||
        vocab.english3.substring(min(3,vocab.english3.length),len7).toLowerCase().contains(query.toLowerCase()) && vocab.englishMain.substring(0,min(3,vocab.english3.length)).toLowerCase() == "to "||
        vocab.english4.substring(min(3,vocab.english4.length),len8).toLowerCase().contains(query.toLowerCase()) && vocab.englishMain.substring(0,min(3,vocab.english4.length)).toLowerCase() == "to "
    ){
      val -= 1000;
    }
    if( vocab.englishMain.toLowerCase().contains(query.toLowerCase())  ||
        vocab.english2.toLowerCase().contains(query.toLowerCase()) ||
        vocab.english3.toLowerCase().contains(query.toLowerCase()) ||
        vocab.english4.toLowerCase().contains(query.toLowerCase()) ||
      normalise(vocab.arabicMain).contains(normalise(query)) ){
      val -= 100;
    }
    if( vocab.englishMain.toLowerCase() == query.toLowerCase()  ||
        vocab.english2.toLowerCase() == query.toLowerCase() ||
        vocab.english3.toLowerCase()==query.toLowerCase() ||
        vocab.english4.toLowerCase()== query.toLowerCase() ||
        vocab.adjectiveEng.toLowerCase()== query.toLowerCase() ||
        vocab.verbEng.toLowerCase()== query.toLowerCase() ||
        vocab.masderENG.toLowerCase()== query.toLowerCase() ||
        normalise(vocab.masder) == normalise(query) ||
        normalise(vocab.adjective) == normalise(query) ||
        normalise(vocab.verb) == normalise(query) ||
        normalise(vocab.arabicMain) == normalise(query)){
      val -= 5000;
    }
    return val;
  }

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Search Word',
    onChanged: searchVocab,
  );
  Widget buildVocab(Vocab vocab, DeewanUserData deewanUserData) => needsSubT(vocab) ? ListTile(
      //leading: Text(vocab.englishMain),
  title: showVocab(vocab),
      subtitle: showSubtitle(vocab),
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
      ):ListTile(
    //leading: Text(vocab.englishMain),
      title: showVocab(vocab),
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
  )
  ;
  needsSubT(Vocab vocab){
    if( vocab.englishMain.toLowerCase().contains(query.toLowerCase())  ||
        vocab.english2.toLowerCase().contains(query.toLowerCase()) ||
        vocab.english3.toLowerCase().contains(query.toLowerCase()) ||
        vocab.english4.toLowerCase().contains(query.toLowerCase()) ||
        normalise(vocab.arabicMain).contains(query.toLowerCase()) ){
      return false;
    }else{
      return true;
    }
  }

  Widget showVocab(Vocab vocab) => query=="" ? Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
        Flexible(child:Text(vocab.englishMain,overflow: TextOverflow.ellipsis,)), Text(vocab.arabicMain,overflow: TextOverflow.ellipsis,)],
  ):
  vocab.englishMain.toLowerCase().contains(query.toLowerCase())||normalise(vocab.arabicMain.toLowerCase()).contains(normalise(query)) ?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:makeBold(vocab.englishMain,query)), Flexible(child:makeBold(vocab.arabicMain,query))],
  ):
  vocab.english2.toLowerCase().contains(query.toLowerCase()) ?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:makeBold(vocab.english2,query)), Flexible(child:makeBold(vocab.arabicMain,query))],
  ):
  vocab.english3.toLowerCase().contains(query.toLowerCase()) ?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:makeBold(vocab.english3,query)), Flexible(child:makeBold(vocab.arabicMain,query))],
  ):

  vocab.english4.toLowerCase().contains(query.toLowerCase()) ?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:makeBold(vocab.english4,query)), Flexible(child:makeBold(vocab.arabicMain,query))],
  ):
  normalise(vocab.masder).contains(normalise(query))||vocab.masderENG.toLowerCase().contains(query.toLowerCase())?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:makeBold(vocab.masderENG,query)), Flexible(child:makeBold(vocab.masder,query))],
  ):
  normalise(vocab.verb).contains(normalise(query))||vocab.verbEng.toLowerCase().contains(query.toLowerCase())?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:makeBold(vocab.verbEng,query)), Flexible(child:makeBold(vocab.verb,query))],
  ):
  normalise(vocab.adjective).contains(query)||vocab.adjectiveEng.toLowerCase().contains(query.toLowerCase())?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:makeBold(vocab.adjectiveEng,query)), Flexible(child:makeBold(vocab.adjective,query))],
  ):
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:Text("FAIL",overflow: TextOverflow.ellipsis,)), Text(vocab.arabicMain,overflow: TextOverflow.ellipsis,)],
  );

  Widget showSubtitle(Vocab vocab) => query=="" ? SizedBox.shrink():
  vocab.englishMain.toLowerCase().contains(query.toLowerCase())||normalise(vocab.arabicMain.toLowerCase()).contains(normalise(query)) ?
  SizedBox.shrink():
  vocab.english2.toLowerCase().contains(query.toLowerCase()) ?
  SizedBox.shrink():
  vocab.english3.toLowerCase().contains(query.toLowerCase()) ?
  SizedBox.shrink():
  vocab.english4.toLowerCase().contains(query.toLowerCase()) ?
  SizedBox.shrink():
  normalise(vocab.masder).contains(normalise(query))||vocab.masderENG.toLowerCase().contains(query.toLowerCase())?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:Text('Masder from: ' + vocab.englishMain,overflow: TextOverflow.ellipsis,)), Text(vocab.arabicMain,overflow: TextOverflow.ellipsis,)],
  ):
  normalise(vocab.verb).contains(normalise(query))||vocab.verbEng.toLowerCase().contains(query.toLowerCase())?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:Text('Verb from: ' + vocab.englishMain,overflow: TextOverflow.ellipsis,)), Text(vocab.arabicMain,overflow: TextOverflow.ellipsis,)],
  ):
  normalise(vocab.adjective).contains(normalise(query))||vocab.adjectiveEng.toLowerCase().contains(query.toLowerCase())?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:Text('Adjective from: ' + vocab.englishMain,overflow: TextOverflow.ellipsis,)), Text(vocab.arabicMain,overflow: TextOverflow.ellipsis,)],
  ):
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:Text("FAIL",overflow: TextOverflow.ellipsis,)), Text(vocab.arabicMain,overflow: TextOverflow.ellipsis,)],
  );

  Widget makeBold(String str, String query){
    var index = normalise(str.toLowerCase()).indexOf(normalise(query.toLowerCase()));
    var ln = query.length;
    if (index == -1){
      return Text(str, overflow: TextOverflow.ellipsis,);
    }
    else {
    return RichText(
      text: TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(text: str.substring(0,index)),
          TextSpan(text: str.substring(index, index +ln), style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: str.substring(index+ln)),

        ],
      ),
    );}
  }

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
      final english2 = vocab.english2.toLowerCase();
      final english3 = vocab.english3.toLowerCase();
      final english4 = vocab.english4.toLowerCase();

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
          masengLower.contains(searchLower)||
          english2.contains(searchLower)||
          english3.contains(searchLower)||
          english4.contains(searchLower);
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

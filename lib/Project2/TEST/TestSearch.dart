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

import '../../shared/constants.dart';

class TestVocabsScreen extends StatefulWidget {
  final List<TestV> vocabs;
  final List favoriteVocabs;

  TestVocabsScreen(this.vocabs, this.favoriteVocabs);

  @override
  TestVocabScreenState createState() => TestVocabScreenState();
}

class TestVocabScreenState extends State<TestVocabsScreen> {
  String query = '';
  late List<TestV> vocabs;

  @override
  void initState() {
    super.initState();
    vocabs = widget.vocabs;
  }

  @override
  Widget build(BuildContext context) {
    List<TestV> filteredData = vocabs.where((item) => item.englisch1.toString() != "-").toList();
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
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          filteredData.sort((a, b) => a.englisch1.toLowerCase().compareTo(b.englisch1.toLowerCase()));
                          query.length >= 2 ? filteredData.sort((a, b) => value(a, query).compareTo(value(b, query))): print('Query short');
                          final vocab = filteredData[index];
                          return buildTestVocab(vocab, deewanUserData);
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

  needsTestSubT(TestV vocab){
    if( vocab.englisch1.toLowerCase().contains(query.toLowerCase())  ||
        normalise(vocab.arabic1).contains(query.toLowerCase()) ){
      return false;
    }else{
      return true;
    }
  }

  value(TestV vocab, String query){
    String normQu = normalise(query);
    String normAr = normalise(vocab.arabic1);
    var len = normQu.length;
    var len1 = min(vocab.englisch1.length, len);
    var lenara = min(normAr.length, len);
    var len2 = min(vocab.englisch2.length, len);
    var len3 = min(vocab.englisch3.length, len);
    var len4 = min(vocab.englisch4.length, len);
    var len5 = min(vocab.englisch1.length, len+3);
    var len6 = min(vocab.englisch2.length, len+3);
    var len7 = min(vocab.englisch3.length, len+3);
    var len8 = min(vocab.englisch4.length, len+3);
    int val = 0;
    if( vocab.englisch1.substring(0,len1).toLowerCase().contains(query.toLowerCase())  ||
        vocab.englisch2.substring(0,len2).toLowerCase().contains(query.toLowerCase()) ||
        vocab.englisch3.substring(0,len3).toLowerCase().contains(query.toLowerCase()) ||
        vocab.englisch4.substring(0,len4).toLowerCase().contains(query.toLowerCase()) ||
        vocab.englisch1.substring(min(3,vocab.englisch1.length),len5).toLowerCase().contains(query.toLowerCase()) && vocab.englisch1.substring(0,min(3,vocab.englisch1.length)).toLowerCase() == "to "||
        vocab.englisch2.substring(min(3,vocab.englisch2.length),len6).toLowerCase().contains(query.toLowerCase()) && vocab.englisch2.substring(0,min(3,vocab.englisch2.length)).toLowerCase() == "to "||
        vocab.englisch3.substring(min(3,vocab.englisch3.length),len7).toLowerCase().contains(query.toLowerCase()) && vocab.englisch3.substring(0,min(3,vocab.englisch3.length)).toLowerCase() == "to "||
        vocab.englisch4.substring(min(3,vocab.englisch4.length),len8).toLowerCase().contains(query.toLowerCase()) && vocab.englisch4.substring(0,min(3,vocab.englisch4.length)).toLowerCase() == "to " ||
        normAr.substring(0,lenara).toLowerCase().contains(normQu.toLowerCase())
    ){
      val -= 1000;
    }
    if( vocab.englisch1.toLowerCase().contains(query.toLowerCase())  ||
        vocab.englisch2.toLowerCase().contains(query.toLowerCase()) ||
        vocab.englisch3.toLowerCase().contains(query.toLowerCase()) ||
        vocab.englisch4.toLowerCase().contains(query.toLowerCase()) ||
        normalise(vocab.arabic1).contains(normalise(query)) ){
      val -= 100;
    }
    if( vocab.englisch1.toLowerCase() == query.toLowerCase()  ||
        vocab.englisch2.toLowerCase() == query.toLowerCase() ||
        vocab.englisch3.toLowerCase()==query.toLowerCase() ||
        vocab.englisch4.toLowerCase()== query.toLowerCase() ||
        vocab.englisch5.toLowerCase()== query.toLowerCase() ||
        vocab.englisch6.toLowerCase()== query.toLowerCase() ||
        vocab.englisch7.toLowerCase()== query.toLowerCase() ||
        normalise(vocab.arabic1) == normalise(query) ||
        normalise(vocab.arabic2) == normalise(query) ||
        normalise(vocab.arabic3) == normalise(query) ||
        normalise(vocab.arabic4) == normalise(query)){
      val -= 5000;
    }
    return val;
  }

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Search Word',
    onChanged: searchVocab,
  );

  Widget showTestSubtitle(TestV vocab) => query=="" ? SizedBox.shrink():
  vocab.englisch1.toLowerCase().contains(query.toLowerCase())||normalise(vocab.arabic1.toLowerCase()).contains(normalise(query)) ?
  SizedBox.shrink():
  vocab.englisch2.toLowerCase().contains(query.toLowerCase())||vocab.englisch3.toLowerCase().contains(query.toLowerCase())||vocab.englisch4.toLowerCase().contains(query.toLowerCase())||vocab.englisch5.toLowerCase().contains(query.toLowerCase())||vocab.englisch6.toLowerCase().contains(query.toLowerCase())||vocab.englisch7.toLowerCase().contains(query.toLowerCase())||vocab.englisch8.toLowerCase().contains(query.toLowerCase())?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:Text('from: ' + vocab.englisch1,overflow: TextOverflow.ellipsis,))],
  ):
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:Text("FAIL",overflow: TextOverflow.ellipsis,))],
  );


  Widget buildTestVocab(TestV vocab, DeewanUserData deewanUserData) => needsTestSubT(vocab) ? ListTile(
    //leading: Text(vocab.englishMain),
      title: showTestVocab(vocab),
      subtitle: showTestSubtitle(vocab),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TestVocabScreen(vocab)),
        );
      }
  ):ListTile(
    //leading: Text(vocab.englishMain),
      title: showTestVocab(vocab),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TestVocabScreen(vocab)),
        );
      });

  Widget showTestVocab(TestV vocab) => query=="" ? Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:Text(vocab.englisch1,overflow: TextOverflow.ellipsis,)), Text(vocab.arabic1,overflow: TextOverflow.ellipsis,)],
  ):
  vocab.englisch1.toLowerCase().contains(query.toLowerCase())||normalise(vocab.arabic1.toLowerCase()).contains(normalise(query)) ?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:makeBold(vocab.englisch1,query)), Text(vocab.arabic1,overflow: TextOverflow.ellipsis,)],
  ):
  vocab.englisch2.toLowerCase().contains(query.toLowerCase()) ?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:makeBold(vocab.englisch2,query)), Text(vocab.arabic1,overflow: TextOverflow.ellipsis,)],
  ):
  vocab.englisch3.toLowerCase().contains(query.toLowerCase()) ?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:makeBold(vocab.englisch3,query)), Text(vocab.arabic1,overflow: TextOverflow.ellipsis,)],
  ):

  vocab.englisch4.toLowerCase().contains(query.toLowerCase()) ?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:makeBold(vocab.englisch4,query)), Text(vocab.arabic1 ,overflow: TextOverflow.ellipsis,)],
  ):
  vocab.englisch5.contains(query.toLowerCase())?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:makeBold(vocab.englisch5,query)), Text(vocab.arabic1,overflow: TextOverflow.ellipsis,)],
  ):
  vocab.englisch6.contains(query.toLowerCase())?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:makeBold(vocab.englisch6,query)), Text(vocab.arabic1,overflow: TextOverflow.ellipsis,)],
  ):
  vocab.englisch6.contains(query.toLowerCase())?
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Flexible(child:makeBold(vocab.englisch6,query)), Text(vocab.arabic1,overflow: TextOverflow.ellipsis,)],
  ):
  vocab.englisch7.contains(query.toLowerCase())?
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Flexible(child:makeBold(vocab.englisch7,query)), Text(vocab.arabic1,overflow: TextOverflow.ellipsis,)],
  ):
  normalise(vocab.arabic1).contains(normalise(query))?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:makeBold(vocab.englisch1,query)), Text(vocab.arabic1,overflow: TextOverflow.ellipsis,)],
  ):
  normalise(vocab.arabic2).contains(query)?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:makeBold(vocab.arabic2,query)), Text(vocab.englisch1,overflow: TextOverflow.ellipsis,)],
  ): normalise(vocab.arabic3).contains(normalise(query))?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:makeBold(vocab.arabic3,query)), Text(vocab.englisch1,overflow: TextOverflow.ellipsis,)],
  ):normalise(vocab.arabic4).contains(normalise(query)) ?
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:makeBold(vocab.arabic4,query)), Text(vocab.englisch1,overflow: TextOverflow.ellipsis,)],
  ):Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child:Text("FAIL",overflow: TextOverflow.ellipsis,)), Text(vocab.arabic1,overflow: TextOverflow.ellipsis,)],
  );

  void searchVocab(String query) {
    final vocabs = widget.vocabs.where((vocab) {
      final englisch1 = vocab.englisch1.toLowerCase();
      final englisch2 = vocab.englisch2.toLowerCase();
      final englisch3 = vocab.englisch3.toLowerCase();
      final englisch4 = vocab.englisch4.toLowerCase();
      final englisch5 = vocab.englisch5.toLowerCase();
      final englisch6 = vocab.englisch6.toLowerCase();
      final englisch7 = vocab.englisch7.toLowerCase();
      final englisch8 = vocab.englisch8.toLowerCase();
      final arabic1 = normalise(vocab.arabic1);
      final arabic2 = normalise(vocab.arabic2);
      final arabic3 = normalise(vocab.arabic3);
      final arabic4 = normalise(vocab.arabic4);


      final searchLower = normalise(query.toLowerCase());

      return englisch1.contains(searchLower) ||
          englisch2.contains(searchLower)||
          englisch3.contains(searchLower)||
          englisch4.contains(searchLower)||
          englisch5.contains(searchLower)||
          englisch6.contains(searchLower)||
          englisch7.contains(searchLower)||
          englisch8.contains(searchLower)||
          arabic1.contains(searchLower)||
          arabic2.contains(searchLower)||
          arabic3.contains(searchLower)||
          arabic4.contains(searchLower);

    }).toList();

    setState(() {
      this.query = query;
      this.vocabs = vocabs;
    });
  }
}
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
          color: globalTextColor,
        ),
        children: <TextSpan>[
          TextSpan(text: str.substring(0,index)),
          TextSpan(text: str.substring(index, index +ln), style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: str.substring(index+ln)),

        ],
      ),
    );}
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

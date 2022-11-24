import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String? uid;
  MyUser({this.uid});
}

class UserData {

  final String? uid;
  final String? name;
  final String? sugars;
  final int? strength;

  UserData({ this.name, this.uid, this.sugars, this.strength});
}

class DeewanUserData {

  final String? uid;
  final String? name;
  final List myFavoriteVocabs;
  final List? forgottenVocab;
  final List personalVocab;
  final String? role;
  final List? doneLevels;



  DeewanUserData({ this.name, this.uid,this.doneLevels, this.forgottenVocab,  this.role = 'user', required this.myFavoriteVocabs, required this.personalVocab,});
}

class SinglePersonalVocabList{
  final String docId;
  final String listName;
  final List personalVocabsList;
  final bool fixed;
  SinglePersonalVocabList({required this.docId, required this.listName, required this.personalVocabsList, this.fixed = false});
}

class Request{
  final String engReq;
  final String araReq;
  final String notesReq;
  final String uid;
  final String reference;
  Request({required this.engReq, required this.araReq, required this.notesReq, required this.uid, required this.reference});
}
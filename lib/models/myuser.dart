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
  final List personalVocab;

  DeewanUserData({ this.name, this.uid, required this.myFavoriteVocabs, required this.personalVocab});
}

class SinglePersonalVocabList{
  final String docId;
  final String listName;
  final List personalVocabsList;
  final bool fixed;
  SinglePersonalVocabList({required this.docId, required this.listName, required this.personalVocabsList, this.fixed = false});
}
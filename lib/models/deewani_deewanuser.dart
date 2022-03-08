import 'package:appwithfirebase/models/myuser.dart';

class Deewani {
  final String name;
  final String sugars;
  final int strength;

  Deewani({required this.name,required this.sugars, required this.strength});

}

class DeewanUsers {
  final String name;
  final List myFavoriteVocabs;
  final List<SinglePersonalVocabList> personalVocab;
  DeewanUsers({required this.name,required this.myFavoriteVocabs, required this.personalVocab});

}
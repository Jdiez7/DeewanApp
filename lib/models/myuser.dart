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

  DeewanUserData({ this.name, this.uid, required this.myFavoriteVocabs,});
}

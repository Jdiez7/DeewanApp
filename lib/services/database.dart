import 'package:appwithfirebase/Project2/Search/vocab.dart';
import 'package:appwithfirebase/models/deewani_deewanuser.dart';
import 'package:appwithfirebase/models/myuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String? uid;

  DataBaseService({this.uid});

  // collection reference
  final CollectionReference deewanCollection =
      FirebaseFirestore.instance.collection('deewans');

  Future<void> updateUserData(String sugars, String name, int strength) async {
    return await deewanCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  //Deewani list from snapshot
  List<Deewani> _deewaniListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Deewani(
        name: doc.get('name') ?? '',
        strength: doc.get('strength') ?? 0,
        sugars: doc.get('sugars') ?? 0,
      );
    }).toList();
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.get('name'),
        sugars: snapshot.get('sugars'),
        strength: snapshot.get('strength'));
  }

  //Deewan userData from snapshot
  DeewanUserData _deewanUserDataFromSnapshot(DocumentSnapshot snapshot) {
    return DeewanUserData(
      uid: uid,
      name: snapshot.get('name'),
      myFavoriteVocabs: snapshot.get('myFavoriteVocabs'),
    );
  }

// get deewani stream
  Stream<List<Deewani>> get deewans {
    return deewanCollection.snapshots().map(_deewaniListFromSnapshot);
  }

  // get user doc stream

  Stream<UserData> get userData {
    return deewanCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // get DeewanUserData

  Stream<UserData> get deewanUserData {
    return deewanCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}

class DeewanDataBaseService {
  final String? uid;

  DeewanDataBaseService({this.uid});

  // collection reference
  final CollectionReference deewanUserCollection =
      FirebaseFirestore.instance.collection('deewanUsers');

  final CollectionReference vocabularyCollection =
      FirebaseFirestore.instance.collection('Vocabulary');

  Future<void> updateDeewanUserData(String name, List myFavoriteVocabs) async {
    return await deewanUserCollection.doc(uid).set({
      'name': name,
      'myFavoriteVocabs': myFavoriteVocabs,
    });
  }

  Future<void> updateDeewanUserFavorite(List myFavoriteVocabs) async {
    return await deewanUserCollection.doc(uid).update({
      'myFavoriteVocabs': myFavoriteVocabs,
    });
  }

  //Deewanusers from snapshot
  List<DeewanUsers> _deewanUserListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DeewanUsers(
        name: doc.get('name') ?? '',
        myFavoriteVocabs: doc.get('myFavoriteVocab') ?? <int>[],
      );
    }).toList();
  }

  //Deewan userData from snapshot
  DeewanUserData _deewanUserDataFromSnapshot(DocumentSnapshot snapshot) {
    return DeewanUserData(
      uid: uid,
      name: snapshot.get('name'),
      myFavoriteVocabs: snapshot.get('myFavoriteVocabs'),
    );
  }

// get deewani stream
  Stream<List<DeewanUsers>> get deewanUsers {
    return deewanUserCollection.snapshots().map(_deewanUserListFromSnapshot);
  }

  // get user doc stream

  Stream<DeewanUserData> get deewanUserData {
    return deewanUserCollection
        .doc(uid)
        .snapshots()
        .map(_deewanUserDataFromSnapshot);
  }

  List<Vocab> _vocabListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final id = int.tryParse(doc.get('id'));
      if (id == null) throw Exception('couldn\'t pass ID');
      return Vocab(
        id: id,
        type: doc.get('englishMain') ?? 'NO ENTRY',
        arabicMain: doc.get('arabicMain') ?? 'NO ENTRY',
        fusha: doc.get('fusha') ?? 'NO ENTRY',
        englishMain: doc.get('englishMain') ?? 'NO ENTRY',
        englishMaincom: doc.get('englishMaincom') ?? 'NO ENTRY',
        english2: doc.get('english2') ?? 'NO ENTRY',
        english2com: doc.get('english2com') ?? 'NO ENTRY',
        english3: doc.get('english3') ?? 'NO ENTRY',
        english3com: doc.get('english3com') ?? 'NO ENTRY',
        english4: doc.get('english4') ?? 'NO ENTRY',
        english4com: doc.get('english4com') ?? 'NO ENTRY',
        syn1: doc.get('syn1') ?? 'NO ENTRY',
        syn2: doc.get('syn2') ?? 'NO ENTRY',
        syn3: doc.get('syn3') ?? 'NO ENTRY',
        verb: doc.get('verb') ?? 'NO ENTRY',
        verbEng: doc.get('verbEng') ?? 'NO ENTRY',
        nomVerbType: doc.get('nomVerbType') ?? 'NO ENTRY',
        nomVerbAra: doc.get('nomVerbAra') ?? 'NO ENTRY',
        nomVerbEng: doc.get('nomVerbEng') ?? 'NO ENTRY',
        noun: doc.get('noun') ?? 'NO ENTRY',
        nounEng: doc.get('nounEng') ?? 'NO ENTRY',
        adjective: doc.get('adjective') ?? 'NO ENTRY',
        adjectiveEng: doc.get('adjectiveEng') ?? 'NO ENTRY',
        masder: doc.get('masder') ?? 'NO ENTRY',
        masderENG: doc.get('masderENG') ?? 'NO ENTRY',
        ex1ENG: doc.get('ex1ENG') ?? 'NO ENTRY',
        ex1ARA: doc.get('ex1ARA') ?? 'NO ENTRY',
        ex2ENG: doc.get('ex2ENG') ?? 'NO ENTRY',
        ex2ARA: doc.get('ex2ARA') ?? 'NO ENTRY',
        ex3ENG: doc.get('ex3ENG') ?? 'NO ENTRY',
        ex3ARA: doc.get('ex3ARA') ?? 'NO ENTRY',
        vERBprep1: doc.get('vERBprep1') ?? 'NO ENTRY',
        vERBprep1com: doc.get('vERBprep1com') ?? 'NO ENTRY',
        vERBprep2: doc.get('vERBprep2') ?? 'NO ENTRY',
        vERBprep2com: doc.get('vERBprep2com') ?? 'NO ENTRY',
        vERBprep3: doc.get('vERBprep3') ?? 'NO ENTRY',
        vERBprep3com: doc.get('vERBprep3com') ?? 'NO ENTRY',
        vERBform: doc.get('vERBform') ?? 'NO ENTRY',
        nOUNtype: doc.get('nOUNtype') ?? 'NO ENTRY',
        nOUNplural: doc.get('nOUNplural') ?? 'NO ENTRY',
        nounpluralType: doc.get('nounpluralType') ?? 'NO ENTRY',
        aDJECTIVEfemale: doc.get('aDJECTIVEfemale') ?? 'NO ENTRY',
        aDJECTIVEplMale: doc.get('aDJECTIVEplMale') ?? 'NO ENTRY',
        aDJECTIVEplFemale: doc.get('aDJECTIVEplFemale') ?? 'NO ENTRY',
        aDJECTIVEpltype: doc.get('aDJECTIVEpltype') ?? 'NO ENTRY',
        pREPex1ENG: doc.get('pREPex1ENG') ?? 'NO ENTRY',
        pREPex1ARA: doc.get('pREPex1ARA') ?? 'NO ENTRY',
        pREPex2ENG: doc.get('pREPex2ENG') ?? 'NO ENTRY',
        pREPex2ARA: doc.get('pREPex2ARA') ?? 'NO ENTRY',
        pREPex3ENG: doc.get('pREPex3ENG') ?? 'NO ENTRY',
        pREPex3ARA: doc.get('pREPex3ARA') ?? 'NO ENTRY',
        pREPex4ENG: doc.get('pREPex4ENG') ?? 'NO ENTRY',
        pREPex4ARA: doc.get('pREPex4ARA') ?? 'NO ENTRY',
        lvl: doc.get('lvl') ?? 'NO ENTRY',
      );
    }).toList();
  }

  // get deewani stream
  Stream<List<Vocab>> get backendVocabs {
    return vocabularyCollection.snapshots().map(_vocabListFromSnapshot);
  }
}

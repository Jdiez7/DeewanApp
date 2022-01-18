import 'package:appwithfirebase/Project2/Search/vocab.dart';
import 'package:appwithfirebase/models/deewani_deewanuser.dart';
import 'package:appwithfirebase/models/myuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class DeewanDataBaseService {
  final String? uid;

  DeewanDataBaseService({this.uid});

  // collection reference
  final CollectionReference deewanUserCollection =
  FirebaseFirestore.instance.collection('deewanUsers');

  final CollectionReference vocabularyCollection =
  FirebaseFirestore.instance.collection('Vocabulary');

  final databaseReference = FirebaseFirestore.instance;

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
  List<DeewanUsers> _deewanUserListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return DeewanUsers(
        name: doc.get('name') ?? '',
        myFavoriteVocabs: doc.get('myFavoriteVocab') ?? <int>[],
      );
    }).toList();
  }

  //Deewan userData from snapshot
  DeewanUserData _deewanUserDataFromSnapshot(DocumentSnapshot snapshot){
    return DeewanUserData(
      uid: uid,
      name: snapshot.get('name'),
      myFavoriteVocabs: snapshot.get('myFavoriteVocabs'),);
  }


// get deewani stream
  Stream<List<DeewanUsers>> get deewanUsers {
    return deewanUserCollection.snapshots()
        .map(_deewanUserListFromSnapshot);
  }

  // get user doc stream

  Stream<DeewanUserData> get deewanUserData{
    return deewanUserCollection.doc(uid).snapshots().map(_deewanUserDataFromSnapshot);
  }

  List<Vocab> _vocabListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      print('doc =====> ${doc.id}');
      final id = int.tryParse(doc.get('id'));
      if(id == null) throw Exception('couldn\'t pass ID');
      return Vocab(
        id: id,
        englishMain: doc.get('englishMain') ?? 'NO ENTRY',
        arabicMain: doc.get('arabicMain') ?? 'NO ENTRY',
        exampleSentence: doc.get('exampleSentence') ?? 'NO ENTRY',
      );
    }).toList();
  }

  // get vocab stream

  Stream<List<Vocab>> get backendVocabs {
    return vocabularyCollection.snapshots()
        .map(_vocabListFromSnapshot);
 /* Stream<List<Vocab>> get backendVocabs {
    return vocabularyCollection.snapshots()
        .map(_vocabListFromSnapshot);*/
  }


}



















//nur damit Sachen noch funktionieren die ich eigentlich nicht mehr brauche

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
  List<Deewani> _deewaniListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Deewani(
        name: doc.get('name') ?? '',
        strength: doc.get('strength') ?? 0,
        sugars: doc.get('sugars') ?? 0,
      );
    }).toList();
  }
  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
        uid: uid,
        name: snapshot.get('name'),
        sugars: snapshot.get('sugars'),
        strength: snapshot.get('strength'));
  }

  //Deewan userData from snapshot
  DeewanUserData _deewanUserDataFromSnapshot(DocumentSnapshot snapshot){
    return DeewanUserData(
      uid: uid,
      name: snapshot.get('name'),
      myFavoriteVocabs: snapshot.get('myFavoriteVocabs'),);
  }


// get deewani stream
  Stream<List<Deewani>> get deewans {
    return deewanCollection.snapshots()
        .map(_deewaniListFromSnapshot);
  }

  // get user doc stream

  Stream<UserData> get userData{
    return deewanCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // get DeewanUserData

  Stream<UserData> get deewanUserData{
    return deewanCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

}
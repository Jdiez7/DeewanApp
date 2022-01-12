import 'package:appwithfirebase/models/deewani.dart';
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



// get deewani stream
  Stream<List<Deewani>> get deewans {
    return deewanCollection.snapshots()
    .map(_deewaniListFromSnapshot);
  }

  // get user doc stream

  Stream<UserData> get userData{
    return deewanCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}

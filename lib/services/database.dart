import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String? uid;
  DataBaseService({this.uid});

  // collection reference
  final CollectionReference deewanCollection = FirebaseFirestore.instance.collection('deewans');

  Future updateUserData(String sugars, String name, int strength) async{
    return await deewanCollection.doc(uid).set(
      {
        'sugars': sugars,
        'name': name,
        'strength': strength,
      }
    );
  }
// set deewani stream
Stream<QuerySnapshot> get deewans {
    return deewanCollection.snapshots();
}
}
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String uid;
  DataBaseService({required this.uid});

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

}
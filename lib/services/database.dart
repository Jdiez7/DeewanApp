import 'package:appwithfirebase/services/class_vocab.dart';
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
      personalVocab: snapshot.get('personalVocab')
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
  final String? docID;

  DeewanDataBaseService({this.uid, this.docID});

  // collection reference
  final CollectionReference deewanUserCollection =
      FirebaseFirestore.instance.collection('deewanUsers');

  final CollectionReference vocabularyCollection =
      FirebaseFirestore.instance.collection('Vocabulary');

  final CollectionReference requestCollection =
  FirebaseFirestore.instance.collection('requests');

  Future<void> updateDeewanUserData(String name, List myFavoriteVocabs, List<SinglePersonalVocabList> personalVocab, List levels, List forgottenVocab) async {
    return await deewanUserCollection.doc(uid).set({
      'name': name,
      'myFavoriteVocabs': myFavoriteVocabs,
      'personalVocab': personalVocab,
      'role': 'user',
      'doneLevels': levels,
      'forgottenVocab' : forgottenVocab,
    });
  }

  Future<DocumentReference<Map<String, dynamic>>> newRequest(englishReq, arabicReq, notesReq) async {
    return await FirebaseFirestore.instance.collection('requests').add({
      'englishReq': englishReq.text,
      'arabicReq': arabicReq.text,
      'notesReq': notesReq.text,
      'uid': uid,
    });
  }

  Future<void> updateDeewanUserFavorite(List myFavoriteVocabs) async {
    return await deewanUserCollection.doc(uid).update({
      'myFavoriteVocabs': myFavoriteVocabs,
    });
  }

  Future<void> updateForgottenVocab(List forgottenVocab) async {
    return await deewanUserCollection.doc(uid).update({
      'forgottenVocab': forgottenVocab,
    });
  }

  Future<void> updateDoneLevel(List<int> levels) async {
    return await deewanUserCollection.doc(uid).update({
      'doneLevels': levels,
    });
  }


  Future<DocumentReference<Map<String, dynamic>>> addNewFile(name, {bool? fixed}) async {
    return await deewanUserCollection.doc(uid).collection('personalVocabs').add({
      'name': name,
      'vocablist': [],
      'fixed' : fixed,
    });
  }

  Future<void> deleteFile(docid) async {
    return await deewanUserCollection.doc(uid).collection('personalVocabs').doc(docid).delete();
  }

  Future<void> deleteRequest(docid) async {
    return await requestCollection.doc(docid).delete();
  }

  Future<void> updateDeewanUserPersonalVocab(List personalVocab) async {
    return await deewanUserCollection.doc(uid).update({
      'personalVocab': personalVocab,
    });
  }
  Future<void> updatePersonalVocabList(List vocablist, String docID) async {
    return await deewanUserCollection.doc(uid).collection('personalVocabs').doc(docID).update({
      'vocablist': vocablist,
    });
  }

  //Deewanusers from snapshot
  List<DeewanUsers> _deewanUserListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DeewanUsers(
        name: doc.get('name') ?? '',
        myFavoriteVocabs: doc.get('myFavoriteVocabs') ?? <int>[],
        personalVocab: doc.get('personalVocab') ?? <SinglePersonalVocabList>[],
      );
    }).toList();
  }

  List<Request> _requestListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
     /*if(uid.toString()==doc.get('uid')){*/
      return Request(
        araReq: doc.get('arabicReq') ?? '',
        engReq: doc.get('englishReq') ?? '',
        notesReq: doc.get('notesReq') ?? '',
        uid: doc.get('uid') ?? '',
        reference: doc.reference.id,
      );
      }/*}*/).toList();
  }

  List<SinglePersonalVocabList> _personalVocabFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SinglePersonalVocabList(
        docId: doc.reference.id,
        listName: doc.get('name') ?? '',
        personalVocabsList: doc.get('vocablist') ?? <int>[2,3],
        fixed: doc.get('fixed') ?? false,
      );
    }).toList();
  }



  //Deewan userData from snapshot
  DeewanUserData _deewanUserDataFromSnapshot(DocumentSnapshot snapshot) {
    if(snapshot['doneLevels'].length >0 ) {
      if(snapshot['forgottenVocab'].length >0) {
        return DeewanUserData(
          uid: uid,
          name: snapshot.get('name'),
          role: snapshot.get('role') ?? 'user',
          myFavoriteVocabs: snapshot.get('myFavoriteVocabs'),
          personalVocab: snapshot.get('personalVocab'),
          doneLevels: snapshot.get('doneLevels'),
          forgottenVocab:  snapshot.get('forgottenVocab'),
        );
      } else {
        return DeewanUserData(
          uid: uid,
          name: snapshot.get('name'),
          role: snapshot.get('role') ?? 'user',
          myFavoriteVocabs: snapshot.get('myFavoriteVocabs'),
          personalVocab: snapshot.get('personalVocab'),
          doneLevels: snapshot.get('doneLevels') ?? [],
          forgottenVocab: [],
        );
      }}else{

      if(snapshot['forgottenVocab']!=null) {
        return DeewanUserData(
          uid: uid,
          name: snapshot.get('name'),
          role: snapshot.get('role') ?? 'user',
          myFavoriteVocabs: snapshot.get('myFavoriteVocabs'),
          personalVocab: snapshot.get('personalVocab'),
          doneLevels:  [],
          forgottenVocab: snapshot.get('forgottenVocab') ?? [],
        );
      } else {
        return DeewanUserData(
          uid: uid,
          name: snapshot.get('name'),
          role: snapshot.get('role') ?? 'user',
          myFavoriteVocabs: snapshot.get('myFavoriteVocabs'),
          personalVocab: snapshot.get('personalVocab'),
          doneLevels: [],
          forgottenVocab: [],
        );
      }

    }


  }

  SinglePersonalVocabList _personalListFromSnapshot(DocumentSnapshot snapshot) {
    return SinglePersonalVocabList(
      docId: docID ?? '',
      listName: snapshot.get('name'),
      personalVocabsList: snapshot.get('vocablist'),
      fixed: snapshot.get('fixed') ?? false,
    );
  }

  // get requests Stream
  Stream<List<Request>> get requests {
    return requestCollection.snapshots().map(_requestListFromSnapshot);
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

  Stream<SinglePersonalVocabList> get personalList {
    return deewanUserCollection
        .doc(uid).collection('personalVocabs').doc(docID)
        .snapshots()
        .map(_personalListFromSnapshot);
  }



  Stream<List<SinglePersonalVocabList>> get personalVocabData {
    return deewanUserCollection.doc(uid).collection('personalVocabs').snapshots().map(_personalVocabFromSnapshot);
  }

  List<TestV> _testVocabListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final id = int.tryParse(doc.get('id'));
      if (id == null) throw Exception('couldn\'t pass ID');
      return TestV(
        id: id,
        arabic1: doc.get('arabic1') ?? 'NO ENTRY',
        arabic2: doc.get('arabic2') ?? 'NO ENTRY',
        arabic3: doc.get('arabic3') ?? 'NO ENTRY',
        arabic4: doc.get('arabic4') ?? 'NO ENTRY',
        englisch1: doc.get('englisch1') ?? 'NO ENTRY',
        englisch2: doc.get('englisch2') ?? 'NO ENTRY2',
        englisch3: doc.get('englisch3') ?? 'NO ENTRY3',
        englisch4: doc.get('englisch4') ?? 'NO ENTRY4',
        englisch5: doc.get('englisch5') ?? 'NO ENTRY',
        englisch6: doc.get('englisch6') ?? 'NO ENTRY',
        englisch7: doc.get('englisch7') ?? 'NO ENTRY',
        englisch8: doc.get('englisch8') ?? 'NO ENTRY',
        forms1: doc.get('forms1') ?? 'NO ENTRY',
        forms2: doc.get('forms2') ?? 'NO ENTRY',
        forms3: doc.get('forms3') ?? 'NO ENTRY',

      );
    }).toList();
  }

  List<Vocab> _vocabListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final id = int.tryParse(doc.get('id'));
      if (id == null) throw Exception('couldn\'t pass ID');
      return Vocab(
        id: id,
        type: doc.get('englishMain') ?? '',
        arabicMain: doc.get('arabicMain') ?? '',
        fusha: doc.get('fusha') ?? '',
        englishMain: doc.get('englishMain') ?? '',
        englishMaincom: doc.get('englishMaincom') ?? '',
        english2: doc.get('english2') ?? '',
        english2com: doc.get('english2com') ?? '',
        english3: doc.get('english3') ?? '',
        english3com: doc.get('english3com') ?? '',
        english4: doc.get('english4') ?? '',
        english4com: doc.get('english4com') ?? '',
        syn1: doc.get('syn1') ?? '',
        syn2: doc.get('syn2') ?? '',
        syn3: doc.get('syn3') ?? '',
        verb: doc.get('verb') ?? '',
        verbEng: doc.get('verbEng') ?? '',
        nomVerbType: doc.get('nomVerbType') ?? '',
        nomVerbAra: doc.get('nomVerbAra') ?? '',
        nomVerbEng: doc.get('nomVerbEng') ?? '',
        noun: doc.get('noun') ?? '',
        nounEng: doc.get('nounEng') ?? '',
        adjective: doc.get('adjective') ?? '',
        adjectiveEng: doc.get('adjectiveEng') ?? '',
        masder: doc.get('masder') ?? '',
        masderENG: doc.get('masderENG') ?? '',
        ex1ENG: doc.get('ex1ENG') ?? '',
        ex1ARA: doc.get('ex1ARA') ?? '',
        ex2ENG: doc.get('ex2ENG') ?? '',
        ex2ARA: doc.get('ex2ARA') ?? '',
        ex3ENG: doc.get('ex3ENG') ?? '',
        ex3ARA: doc.get('ex3ARA') ?? '',
        vERBprep1: doc.get('vERBprep1') ?? '',
        vERBprep1com: doc.get('vERBprep1com') ?? '',
        vERBprep2: doc.get('vERBprep2') ?? '',
        vERBprep2com: doc.get('vERBprep2com') ?? '',
        vERBprep3: doc.get('vERBprep3') ?? '',
        vERBprep3com: doc.get('vERBprep3com') ?? '',
        vERBform: doc.get('vERBform') ?? '',
        nOUNtype: doc.get('nOUNtype') ?? '',
        nOUNplural: doc.get('nOUNplural') ?? '',
        nounpluralType: doc.get('nounpluralType') ?? '',
        aDJECTIVEfemale: doc.get('aDJECTIVEfemale') ?? '',
        aDJECTIVEplMale: doc.get('aDJECTIVEplMale') ?? '',
        aDJECTIVEplFemale: doc.get('aDJECTIVEplFemale') ?? '',
        aDJECTIVEpltype: doc.get('aDJECTIVEpltype') ?? '',
        aDJECTIVEmale: doc.get('aDJECTIVEmale')?? '',
        aDJECTIVEpl: doc.get('aDJECTIVEpl')?? '',
        pREPex1ENG: doc.get('pREPex1ENG') ?? '',
        pREPex1ARA: doc.get('pREPex1ARA') ?? '',
        pREPex2ENG: doc.get('pREPex2ENG') ?? '',
        pREPex2ARA: doc.get('pREPex2ARA') ?? '',
        pREPex3ENG: doc.get('pREPex3ENG') ?? '',
        pREPex3ARA: doc.get('pREPex3ARA') ?? '',
        pREPex4ENG: doc.get('pREPex4ENG') ?? '',
        pREPex4ARA: doc.get('pREPex4ARA') ?? '',
        lvl: doc.get('lvl') ?? '',
        mp3ID: doc.get('mp3ID') ?? '',
          nomVerbAct: doc.get('nomVerbAct')?? '',
          nomVerbActEng: doc.get('nomVerbActEng')?? '',
          nomVerbPas: doc.get('nomVerbPas')?? '',
          nomVerbPasEng: doc.get('nomVerbPasEng')?? '',
      );
    }).toList();
  }

  // get deewani stream
  Stream<List<Vocab>> get backendVocabs {
    return vocabularyCollection.snapshots().map(_vocabListFromSnapshot);
  }
  Stream<List<TestV>> get testVocabs {
    return vocabularyCollection.snapshots().map(_testVocabListFromSnapshot);
  }
}

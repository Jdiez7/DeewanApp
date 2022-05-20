import 'package:appwithfirebase/models/myuser.dart';
import 'package:appwithfirebase/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on FirebaseUser
  MyUser? _userFromFirebaseUser(User? user){
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // auth change user stream

  Stream<MyUser?> get user {
    return _auth.authStateChanges()
      //.map((User user) => _userFromFirebaseUser(user));
      .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signinAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }

  }

  // sign in with email & pw

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? myUser = result.user;


      return _userFromFirebaseUser(myUser!);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email & pw

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? myDeewanUser = result.user;

      // create a new document for the user with the uid
      await DeewanDataBaseService(uid: myDeewanUser?.uid).updateDeewanUserData('new Deewan user', <int>[], <SinglePersonalVocabList>[]);
      // create deewan Lists
      await DeewanDataBaseService(uid: myDeewanUser?.uid).addNewFile('Verbs', fixed: true);
      await DeewanDataBaseService(uid: myDeewanUser?.uid).addNewFile('Nouns', fixed: true);
      await DeewanDataBaseService(uid: myDeewanUser?.uid).addNewFile('Adjectives', fixed: true);


      return _userFromFirebaseUser(myDeewanUser!);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}
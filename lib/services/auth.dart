import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // get user current status
  Future<FirebaseUser> get getUser => _auth.currentUser();

  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  Future<FirebaseUser> anonLogin() async {

    FirebaseUser user = (await _auth.signInAnonymously()) as FirebaseUser;
    updateUserData(user);
    return user;
  }

  Future<FirebaseUser> googleSignIn() async {
    try {

      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
      );

      FirebaseUser user = (await _auth.signInWithCredential(credential)) as FirebaseUser;
      updateUserData(user);
      return user;

    } catch ( error ) {
      print(error);
      return null;
    }
  }

  Future<void> updateUserData(FirebaseUser user){
    DocumentReference reportRef = _db.collection('reports').document(user.uid);

    return reportRef.setData({
      'uid': user.uid,
      'lastActivity': DateTime.now()
    }, merge: true);
  }


}
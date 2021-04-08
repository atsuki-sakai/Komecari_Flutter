import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Stream<User> get userStateChanges;
  User get currentUser;
  Future<User> signInWithEmailAndPassword({String email, String password});
  Future<User> createUserWithEmailAndPassword(
      {String email, String password, String userName, bool isSeller});
  Future<void> signOut();
  Future<void> passwordReset({String email});
  Future<void> sendEmailValid(email);
}

class Auth implements BaseAuth {
  final _auth = FirebaseAuth.instance;

  @override
  Stream<User> get userStateChanges => FirebaseAuth.instance.authStateChanges();
  @override
  User get currentUser => _auth.currentUser;

  @override
  Future<void> sendEmailValid(email) async {
    _auth.sendSignInLinkToEmail(email: email);
  }

  @override
  Future<User> signInWithEmailAndPassword(
      {String email, String password}) async {
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(
            EmailAuthProvider.credential(email: email, password: password));
    return userCredential.user;
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      {String email, String password, String userName, bool isSeller}) async {
    final UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> passwordReset({String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}

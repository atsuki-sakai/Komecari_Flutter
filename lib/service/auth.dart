import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:komecari_project/helper/custom_firebase_exception.dart';

abstract class BaseAuth {
  Stream<User?> get userStateChanges;
  User? get currentUser;
  Future<User?> signInWithEmailAndPassword({required String email,required String password});
  Future<User?> createUserWithEmailAndPassword(
      {required String email,required String password});
  Future<void> signOut();
  Future<void> passwordReset({required String email});
  Future<void> sendEmailValid();
}

class Auth implements BaseAuth {
  final _auth = FirebaseAuth.instance;

  @override
  Stream<User?> get userStateChanges => FirebaseAuth.instance.authStateChanges();
  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<void> sendEmailValid() async {
    if (_auth.currentUser != null) {
      await _auth.currentUser!.sendEmailVerification();
    } else {
      throw CustomException(
          code: 'user is null', message: 'not fount current user');
    }
  }

  @override
  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(
          EmailAuthProvider.credential(email: email, password: password));
      return userCredential.user;
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<User?> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> passwordReset({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}

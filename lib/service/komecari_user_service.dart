import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:komecari_project/Helper/custom_firebase_exception.dart';
import 'package:komecari_project/model/komecari_user.dart';
import 'package:komecari_project/screens/other/error_page.dart';
import 'package:komecari_project/service/path_generator.dart';
import 'package:komecari_project/service/auth.dart';
import 'package:komecari_project/service/firestore_service.dart';
import 'package:komecari_project/service/storage_service.dart';
import 'package:rxdart/rxdart.dart';

class KomecariUserService {
  final auth = Auth();
  final _firestore = FirestoreService.instance;

  final _komecariUserSubject = BehaviorSubject<KomecariUser?>();
  Stream<KomecariUser?> get userStream => _komecariUserSubject.stream;
  StreamSink<KomecariUser?> get _userState => _komecariUserSubject.sink;

  KomecariUser? get user => _komecariUserSubject.value;

  // FIXME - このクラスがインスタンスかされた時にLogin状態を確認する。問題ない？
  KomecariUserService() {
    this.checkLoginStates();
  }

  void dispose() {
    _komecariUserSubject.close();
  }

  Future<void> checkLoginStates() async {
    if (auth.currentUser != null) {
      await fetchUser(uid: auth.currentUser!.uid);
    }else{
      _userState.add(null);
    }
  }

  Future<void> fetchUser({required String uid}) async {
    try {
      final collectionPath = APIPath.user(userId: uid);
      final snapShot = await _firestore.getData(path: collectionPath);
      if(snapShot.data() == null) throw Exception('snapShot Data is Null...');
      final _user =  KomecariUser.fromMap(snapShot.data()!);
      _userState.add(_user);
    }catch(e){
      rethrow;
    }
  }

  Future<void> createUser(
      {required String email,
      required String password,
      required String userName,
      required bool isSeller,
      File? profileImageFile}) async {

    String? imageUrl;
    final _user = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if(_user == null) throw Exception('Create user error');
    if (profileImageFile != null) {
      final storageCollection = StoragePath.profile(userId: _user.uid);
      await StorageService.instance.uploadFile(
          file: profileImageFile, path: storageCollection, size: 120);
      imageUrl = await StorageService.instance
          .downloadImageLink(path: storageCollection);
    }

    final komecariUser = KomecariUser(
      uid: _user.uid,
      userName: userName,
      email: email,
      isSeller: isSeller,
      profileImageUrl: imageUrl,
    );
    final userCollection = APIPath.user(userId: _user.uid);
    await _firestore.setData(path: userCollection, data: komecariUser.toMap());
  }

  Future<void> login(
      {required String email, required String password}) async {
    final _user =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    if (!_user!.emailVerified) {
      throw CustomException(
          code: '認証エラー', message: '送られてきたメールを確認してください。メールを確認の上再度ログインしてください。');
    }
    final userCollection = APIPath.user(userId: _user.uid);
    final userData = await _firestore.getData(path: userCollection);
    _userState.add(KomecariUser.fromMap(userData.data()!));
  }

  Future<void> logOut({required String uid}) async {
    await auth.signOut();
    _userState.add(null);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  Future<DocumentSnapshot> getData({@required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapShot = await reference.get();
    print(snapShot);
    return snapShot;
  }

  Future<void> deleteData({@required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    try {
      final reference = FirebaseFirestore.instance.doc(path);
      await reference.set(data);
    }catch(e){
      rethrow;
    }
  }

  Future<DocumentSnapshot> getData({required String path}) async {
    try {
      final reference = FirebaseFirestore.instance.doc(path);
      final snapShot = await reference.get();
      return snapShot;
    }catch(e){
      rethrow;
    }
  }

  Future<void> deleteData({required String path}) async {
    try {
      final reference = FirebaseFirestore.instance.doc(path);
      await reference.delete();
    }catch(e){
      rethrow;
    }
  }
}

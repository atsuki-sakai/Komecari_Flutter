import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomException implements Exception {
  const CustomException({required this.code, required this.message});

  final String code;

  final String message;
}

class CustomFirebaseException {
  String code = '';
  String message = '';

  static CustomFirebaseException transformJPLanguage(
      {required FirebaseException e}) {
    switch (e.code) {
      case 'wrong-password':
        final exception = CustomFirebaseException();
        exception.code = '無効なパスワード';
        exception.message = 'パスワードが短すぎるか、ユーザーがパスワードを持っていません。';
        return exception;
        break;
      case 'invalid-email':
        final exception = CustomFirebaseException();
        exception.code = '無効なメールアドレス';
        exception.message = 'メールアドレスの形式が正しくありません。';
        return exception;
        break;
      case 'weak-password':
        final exception = CustomFirebaseException();
        exception.code = '無効なパスワード';
        exception.message = 'パスワードが無効であるか、入力形式が正しくありません。';
        return exception;
        break;
      case 'user-not-found':
        final exception = CustomFirebaseException();
        exception.code = 'ユーザーが見つかりません';
        exception.message = 'このメールアドレスに対応する、ユーザーは存在しません。 ユーザーが削除された可能性があります。';
        return exception;
        break;
      case 'email-already-in-use':
        final exception = CustomFirebaseException();
        exception.code = '使用中のメールアドレス';
        exception.message = 'メールアドレスはすでに別のアカウントで使用されています。';
        return exception;
        break;
      case 'missing-email':
        final exception = CustomFirebaseException();
        exception.code = 'メールアドレスが空です';
        exception.message = 'メールアドレスを入力する必要があります。';
        return exception;
        break;
      default:
        final exception = CustomFirebaseException();
        exception.code = e.code;
        exception.message = e.message ?? 'No Message';
        return exception;
        break;
    }
  }
}

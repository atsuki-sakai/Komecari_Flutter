import 'dart:io';
import 'package:flutter/material.dart';

enum SignInFormType {
  signIn,
  signUp,
}

class SignInModel {
  SignInModel({
    this.email = '',
    this.password = '',
    this.userName = '',
    this.profileImageFile,
    this.isSeller = false,
    this.formType = SignInFormType.signIn,
    this.isSubmitted = false,
    this.isLoading = false,
  });

  String email;
  String password;
  String userName;
  File? profileImageFile;
  bool isSeller = false;
  SignInFormType formType;
  bool isSubmitted = false;
  bool isLoading = false;
  bool get showPasswordResetButton => isSubmitted == true && email.isNotEmpty;
  bool get inputCompleted => email.isNotEmpty || password.isNotEmpty || userName.isNotEmpty;


  String get primaryText =>
      formType == SignInFormType.signIn ? 'Sign In' :  'Sign Up';

  String get secondaryText => formType == SignInFormType.signIn
      ? 'アカウントをお持ちでないですか？'
      : 'すでにアカウントをお持ちですか?';

  String get buttonText =>
      formType == SignInFormType.signIn ? 'Sign In' : 'Sign Up';

  IconData get buttonIcon =>
      formType == SignInFormType.signIn ? Icons.login : Icons.create;

  SignInModel copyWith({
    String? email,
    String? password,
    String? userName,
    File? profileImageFile,
    bool? isSeller,
    SignInFormType? formType,
    bool? isSubmitted,
    bool? isLoading,
    bool? showPasswordResetButton,
  }) {
    return SignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      userName: userName ?? this.userName,
      profileImageFile: profileImageFile ?? this.profileImageFile,
      isSeller: isSeller ?? this.isSeller,
      formType: formType ?? this.formType,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

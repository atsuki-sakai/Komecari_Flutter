import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:komecari_project/screens/sign_in/sign_in_model.dart';
import 'package:komecari_project/service/komecari_user_service.dart';

class SignInBloc {
  SignInBloc({@required this.komecariService});

  final KomecariUserService komecariService;
  final picker = ImagePicker();

  final StreamController<SignInModel> _modelController =
      StreamController<SignInModel>();

  Stream<SignInModel> get modelStream => _modelController.stream;
  SignInModel _model = SignInModel();

  void dispose() {
    _modelController.close();
  }

  Future<void> showCamera() async {
    final pickerFile = await picker.getImage(source: ImageSource.camera);
    if (pickerFile != null) {
      updateWith(profileImageFile: File(pickerFile.path));
    }
  }

  Future<void> showGallery() async {
    final pickerFile = await picker.getImage(source: ImageSource.gallery);
    if (pickerFile != null) {
      updateWith(profileImageFile: File(pickerFile.path));
    }
  }

  void toggleFormType() {
    final _formType = _model.formType == SignInFormType.signIn
        ? SignInFormType.register
        : SignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      isLoading: false,
      isSubmitted: false,
      formType: _formType,
    );
  }

  void takeOverTheInputFromSignInPage() {
    updateWith(
      formType: SignInFormType.signIn,
    );
  }

  Future<void> sendEmailVarification() async {
    try {
      await komecariService.auth.sendEmailValid();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword() async {
    try {
      await komecariService.auth.passwordReset(email: _model.email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login() async {
    updateWith(isLoading: true, isSubmitted: true);
    try {
      await komecariService.login(
          email: _model.email, password: _model.password);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  Future<void> register() async {
    updateWith(isLoading: true, isSubmitted: true);
    try {
      await komecariService.createUser(
          email: _model.email,
          password: _model.password,
          userName: _model.userName,
          profileImageFile: _model.profileImageFile,
          isSeller: _model.isSeller);
      await sendEmailVarification();
      updateWith(profileImageFile: null);
      takeOverTheInputFromSignInPage();
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  void updateEmail({@required String email}) => updateWith(email: email);

  void updatePassword({@required String password}) =>
      updateWith(password: password);

  void updateUserName({@required String userName}) =>
      updateWith(userName: userName);

  void updateProfile(File profileImageFile) => updateWith(
        profileImageFile: profileImageFile,
      );

  void reset() {
    updateWith(
      email: '',
      password: '',
      userName: '',
      profileImageFile: null,
      isSeller: false,
      formType: SignInFormType.signIn,
      isSubmitted: false,
      isLoading: false,
      showPasswordResetButton: false,
    );
  }

  void updateWith({
    String email,
    String password,
    String userName,
    File profileImageFile,
    bool isSeller,
    SignInFormType formType,
    bool isSubmitted,
    bool isLoading,
    bool showPasswordResetButton,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      userName: userName,
      profileImageFile: profileImageFile,
      isSeller: isSeller,
      formType: formType,
      isSubmitted: isSubmitted,
      isLoading: isLoading,
      showPasswordResetButton: showPasswordResetButton,
    );
    _modelController.add(_model);
  }
}

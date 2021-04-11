import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:komecari_project/component/alert_dialog.dart';
import 'package:komecari_project/component/custom_text/title_text.dart';
import 'package:komecari_project/Helper/custom_firebase_exception.dart';
import 'package:komecari_project/screens/sign_in/sign_in_bloc.dart';
import 'package:komecari_project/screens/sign_in/sign_in_model.dart';
import 'package:komecari_project/service/komecari_user_service.dart';
import 'package:provider/provider.dart';

class SignInInputForm extends StatefulWidget {
  SignInInputForm({Key key, @required this.signInBloc}) : super(key: key);

  final SignInBloc signInBloc;

  static Widget create(
      BuildContext context, KomecariUserService komecariService) {
    return Provider(
      create: (_) => SignInBloc(komecariService: komecariService),
      child: Consumer<SignInBloc>(
        builder: (_, bloc, __) {
          return SignInInputForm(signInBloc: bloc);
        },
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _SignInInputFormState createState() => _SignInInputFormState();
}

class _SignInInputFormState extends State<SignInInputForm> {
  SignInBloc get signInBloc => widget.signInBloc;

  // - Properties

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode userNameFocusNode = FocusNode();

  // - Override
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    userNameFocusNode.dispose();
    super.dispose();
  }

  // - Functions

  Future<void> showSelectCameraOrGallery() async {
    FocusScope.of(context).unfocus();
    final selectType = await showAlertDialog(
      context,
      title: 'Profile画像を選択',
      content: 'プロフィール画像を選択します。設定しない場合は初期画像が選択されます。',
      defaultActionText: 'カメラを起動',
      cancelActionText: 'アルバムを開く',
    );
    if (selectType) {
      await signInBloc.showCamera();
    } else {
      await signInBloc.showGallery();
    }
  }

  Future<void> _toggleFormType() async {
    signInBloc.toggleFormType();
    emailController.clear();
    passwordController.clear();
    userNameController.clear();
  }

  Future<void> resetPassword() async {
    try {
      final toSend = await showAlertDialog(context,
          title: 'パスワードを再設定する',
          content: '入力されたアドレス宛に再設定用のメールをお送信しますパスワードを再設定しますか？。',
          defaultActionText: '送信',
          cancelActionText: '送信しない');
      if (toSend) {
        signInBloc.resetPassword();
      }
    } catch (e) {
      exceptionHandler(exception: e);
    } finally {
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _login(SignInModel model) async {
    if (!model.inputCompleted) {
      throw CustomException(
          code: '入力エラー', message: '入力がされていない項目があります。再度確認してください。');
    }
    try {
      await signInBloc.login();
      Navigator.pop(context);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _register(SignInModel model) async {
    if (!model.inputCompleted) {
      throw CustomException(
          code: '入力エラー', message: '入力がされていない項目があります。再度確認してください。');
    }
    try {
      await signInBloc.register();
      await showAlertDialog(context,
          title: '登録完了',
          content:
              'メールアドレス確認用のメールを登録されたメールアドレス宛に送信しました。認証してからログインしてください。メールが届くまで１〜２分かかる場合があります。',
          defaultActionText: 'OK');
    } catch (e) {
      rethrow;
    } finally {}
  }

  Future<void> _submit(SignInModel model) async {
    try {
      if (model.formType == SignInFormType.signIn) {
        await _login(model);
      } else {
        await _register(model);
      }
    } catch (e) {
      exceptionHandler(exception: e);
    } finally {
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> exceptionHandler({@required Exception exception}) async {
    if (exception is FirebaseException) {
      final _e = CustomFirebaseException.transformJPLanguage(e: exception);
      showAlertDialog(context,
          title: _e.code, content: _e.message, defaultActionText: 'OK');
    } else if (exception is CustomException) {
      if (exception.code == '認証エラー') {
        final toSend = await showAlertDialog(context,
            title: exception.code,
            content: exception.message,
            defaultActionText: '再送する',
            cancelActionText: 'OK');
        if (toSend) {
          signInBloc.sendEmailVarification();
        }
      } else {
        showAlertDialog(context,
            title: exception.code,
            content: exception.message,
            defaultActionText: 'OK');
      }
    } else {
      showAlertDialog(context,
          title: 'NoSuchMethod Error',
          content: exception.toString(),
          defaultActionText: 'OK');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SignInModel>(
        initialData: SignInModel(),
        stream: widget.signInBloc.modelStream,
        builder: (context, snapShot) {
          final _model = snapShot.data;
          return Column(
            children: [
              TitleText(
                text: _model.primaryText,
                fontSize: 26.0,
              ),
              SizedBox(
                height: 12.0,
              ),
              changeFormTypeContents(_model),
              SizedBox(
                height: 8,
              ),
              buildEmailTextField(context, _model),
              SizedBox(
                height: 8.0,
              ),
              _buildPasswordTextField(context, _model),
              if (_model.formType == SignInFormType.register) ...{
                SizedBox(
                  height: 8.0,
                ),
                _buildSelectAccountTypeSwitch(model: _model),
              },
              SizedBox(
                height: 12.0,
              ),
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      _model.isLoading == false ? () => _submit(_model) : null,
                  icon: Icon(_model.buttonIcon),
                  label: Text(
                    _model.buttonText,
                    style: GoogleFonts.montserrat(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextButton(
                onPressed: _model.isLoading == false ? _toggleFormType : null,
                child: Text(
                  _model.secondaryText,
                  style: GoogleFonts.notoSans(
                    fontSize: 14.0,
                    color: Colors.blue.shade300,
                  ),
                ),
              ),
              if(_model.showPasswordResetButton)...{
                TextButton(
                  child: Text('パスワードをお忘れですか？'),
                  onPressed: resetPassword,
                ),
              }
            ],
          );
        });
  }

  InkWell _buildSelectedImage(SignInModel _model) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60.0),
          border: Border.all(color: Colors.grey.shade500, width: 3),
        ),
        height: 120,
        width: 120,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(60.0),
          child: Image.file(
            _model.profileImageFile,
            fit: BoxFit.fill,
          ),
        ),
      ),
      onTap: showSelectCameraOrGallery,
    );
  }

  Stack _buildChoiceImage() {
    return Stack(
      children: [
        InkWell(
          child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade400, width: 1.5),
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_a_photo_outlined,
                size: 70,
                color: Colors.blue.shade400,
              )),
          onTap: showSelectCameraOrGallery,
        ),
        Positioned(
            bottom: 15,
            left: 30,
            right: 20,
            child: TitleText(
              text: 'Tap Here.',
              fontSize: 14.0,
              color: Colors.black45,
            )),
      ],
    );
  }

  Widget changeFormTypeContents(SignInModel _model) {
    if (_model.formType == SignInFormType.register) {
      if (_model.profileImageFile == null) {
        return Column(
          children: [
            _buildChoiceImage(),
            SizedBox(
              height: 12.0,
            ),
            _buildUserNameTextField(context, _model),
          ],
        );
      } else {
        return Column(
          children: [
            _buildSelectedImage(_model),
            SizedBox(
              height: 12.0,
            ),
            _buildUserNameTextField(context, _model),
          ],
        );
      }
    } else {
      return SizedBox();
    }
  }

  Row _buildSelectAccountTypeSwitch({SignInModel model}) {
    return Row(
      children: [
        Icon(
          model.isSeller ? Icons.check_circle_outline : Icons.cancel_outlined,
          color: model.isSeller ? Colors.green.shade300 : Colors.red.shade300,
          size: 32,
        ),
        SizedBox(
          width: 12.0,
        ),
        TitleText(
          text: model.isSeller ? 'お米を出品する。' : 'お米を出品しない。',
          fontSize: 18.0,
          color: model.isSeller ? Colors.blue.shade300 : Colors.grey.shade400,
        ),
        Spacer(),
        Switch(
          value: model.isSeller,
          onChanged: (value) {
            setState(() {
              model.isSeller = value;
            });
          },
        ),
      ],
    );
  }

  TextField buildEmailTextField(BuildContext context, SignInModel model) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      focusNode: emailFocusNode,
      autocorrect: false,
      onChanged: (email) => signInBloc.updateEmail(email: email),
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(passwordFocusNode);
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.blue.shade500)),
        hintText: 'sample@email.com',
        labelText: 'Email',
        errorText: model.isSubmitted == true && model.email.isEmpty
            ? 'メールアドレスが入力されていません。'
            : null,
      ),
    );
  }

  TextField _buildPasswordTextField(BuildContext context, SignInModel model) {
    return TextField(
      keyboardType: TextInputType.visiblePassword,
      controller: passwordController,
      focusNode: passwordFocusNode,
      obscureText: true,
      onChanged: (password) => signInBloc.updatePassword(password: password),
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.blue.shade500)),
        hintText: 'password',
        labelText: 'Password',
        errorText: model.isSubmitted == true && model.password.isEmpty
            ? 'パスワードが入力されていません。'
            : null,
      ),
    );
  }

  TextField _buildUserNameTextField(BuildContext context, SignInModel model) {
    return TextField(
      keyboardType: TextInputType.text,
      controller: userNameController,
      focusNode: userNameFocusNode,
      onChanged: (userName) => signInBloc.updateUserName(userName: userName),
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(emailFocusNode);
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.blue.shade500)),
        hintText: 'Yamada Tarou',
        labelText: 'User Name',
        errorText: model.isSubmitted == true && model.userName.isEmpty
            ? 'ユーザー名が入力されていません。'
            : null,
      ),
    );
  }
}

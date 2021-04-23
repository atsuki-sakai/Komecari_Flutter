import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:komecari_project/component/custom_app_bar.dart';
import 'package:komecari_project/component/custom_text/title_text.dart';
import 'package:komecari_project/component/safe_scaffold.dart';
import 'package:komecari_project/screens/sign_in/sign_in_bloc.dart';
import 'package:komecari_project/screens/sign_in/sign_in_input_form.dart';
import 'package:komecari_project/service/komecari_user_service.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({required this.komecariService});
  final KomecariUserService komecariService;
  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SignInInputForm.launchProvider(context, komecariService),
        ),
      ),
    );
  }
}

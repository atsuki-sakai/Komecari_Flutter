import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:komecari_project/component/custom_text/title_text.dart';
import 'package:komecari_project/component/safe_scaffold.dart';
import 'package:komecari_project/screens/sign_in/sign_in_input_form.dart';
import 'package:komecari_project/service/komecari_user_service.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({@required this.komecariService});

  final KomecariUserService komecariService;

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 40),
          child: _buildCustomAppBar(context)),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SignInInputForm.create(context, komecariService),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context,
      {bool defaultBackButton = true, List<Widget> actions}) {
    return AppBar(
      leading: defaultBackButton
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_outlined),
            )
          : SizedBox(),
      title: _buildAppBarTitle(),
      shadowColor: Colors.transparent,
      actions: actions ?? actions,
    );
  }

  Row _buildAppBarTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.rice_bowl_outlined),
        SizedBox(
          width: 12.0,
        ),
        TitleText(
          text: 'KOMECARI',
        ),
        SizedBox(
          width: 12.0,
        ),
        Opacity(
          opacity: 0.0,
          child: Icon(Icons.rice_bowl_outlined),
        ),
      ],
    );
  }
}

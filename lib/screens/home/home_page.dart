import 'package:flutter/material.dart';
import 'package:komecari_project/component/custom_drawer.dart';
import 'package:komecari_project/component/custom_text/title_text.dart';
import 'package:komecari_project/model/komecari_user.dart';
import 'package:komecari_project/service/komecari_user_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key, @required this.komecariService}) : super(key: key);
  final KomecariUserService komecariService;

  Widget build(BuildContext context) {
    return StreamBuilder<KomecariUser>(
        stream: komecariService.userStream,
        builder: (context, snapShot) {
          final komecariUser = snapShot.data;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey.shade50,
              shadowColor: Colors.transparent,
              title: _buildAppBarContent(),
            ),
            drawer: CustomDrawer(komecariUser: komecariUser,komecariService: komecariService,),
            body: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  // TODO - Make Home Page Contents
                ],
              ),
            ),
          );
        });
  }

  Row _buildAppBarContent() {
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
          child: Icon(Icons.ac_unit),
        ),
      ],
    );
  }
}

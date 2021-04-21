import 'package:flutter/material.dart';
import 'package:komecari_project/component/safe_scaffold.dart';
import 'package:komecari_project/model/komecari_user.dart';
import 'package:komecari_project/service/komecari_user_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key,@required this.komecariService}) : super(key: key);
  final KomecariUserService komecariService;
  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      body: StreamBuilder<KomecariUser>(
        stream: komecariService.userStream,
        builder: (context, snapshot) {
          final user = snapshot.data;
          return Center(
            child: Text(user != null ? 'Login Home' : 'Home Page'),
          );
        }
      ),
    );
  }
}

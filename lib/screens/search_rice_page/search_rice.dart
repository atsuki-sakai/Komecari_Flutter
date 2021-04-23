import 'package:flutter/material.dart';
import 'package:komecari_project/component/safe_scaffold.dart';
import 'package:komecari_project/helper/transparent_app_bar.dart';
import 'package:komecari_project/model/komecari_user.dart';
import 'package:komecari_project/service/komecari_user_service.dart';

class SearchRicePage extends StatelessWidget {
  const SearchRicePage({Key? key, required this.komecariService}) : super(key: key);
  final KomecariUserService komecariService;
  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      appBar: TransParentAppBar(title: 'お米を探す',),
      body: StreamBuilder<KomecariUser?>(
        stream: komecariService.userStream,
        builder: (context, snapshot) {
          final user = snapshot.data;
          return Center(
            child: Text('Search Rice Page'),
          );
        }
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:komecari_project/component/safe_scaffold.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}

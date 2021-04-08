import 'package:flutter/material.dart';
import 'package:komecari_project/component/custom_text/description_text.dart';
import 'package:komecari_project/component/safe_scaffold.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 160,
              width: 160,
              child: CircularProgressIndicator(
                strokeWidth: 6.0,
                backgroundColor: Colors.amber.shade400,
              )),
          SizedBox(
            height: 30.0,
          ),
          DescriptionText(
            text: 'Now Loading...',
            fontSize: 28.0,
          ),
        ],
      ),
    );
  }
}

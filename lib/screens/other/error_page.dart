import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:komecari_project/component/custom_text/description_text.dart';
import 'package:komecari_project/component/custom_text/title_text.dart';
import 'package:komecari_project/component/safe_scaffold.dart';

class ExceptionErrorPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 120,
            color: Colors.red.shade400,
          ),
          SizedBox(
            height: 20,
          ),
          TitleText(
            text: 'Exception Error',
          ),
          SizedBox(
            height: 10.0,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: DescriptionText(text: '予期せぬエラーが発生しました。アプリを一度閉じて再度お試しください。')),
          SizedBox(
            height: 120,
          ),
          TextButton(
            // exit(0) close app is ios and android only.
            onPressed: () => exit(0),
            child: Text(
              'CLOSE TO APP',
              style: GoogleFonts.montserrat(
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

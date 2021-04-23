import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<bool?> showAlertDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String defaultActionText,
  String? cancelActionText,
}) {
  if (!Platform.isIOS) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: GoogleFonts.notoSans(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent),
            ),
            content: Text(
              content,
              style: GoogleFonts.notoSans(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.black54),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(defaultActionText),
              ),
              if (cancelActionText != null) ...{
                TextButton(
                  child: Text(cancelActionText),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              },
            ],
          );
        });
  } else {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          title,
          style: GoogleFonts.notoSans(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: Colors.blueAccent),
        ),
        content: Text(
          content,
          style: GoogleFonts.notoSans(
              fontSize: 14.0,
              fontWeight: FontWeight.w300,
              color: Colors.black54),
        ),
        actions: <Widget>[
          if (cancelActionText != null) ...{
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelActionText),
            ),
          },
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(defaultActionText),
          ),
        ],
      ),
    );
  }
}

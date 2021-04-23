import 'package:flutter/material.dart';

Future<void> showSnackBar(BuildContext context,
    {required Widget content, hideSec = 3,Color color = Colors.grey}) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: content,
    duration: Duration(seconds: hideSec),
    backgroundColor: color,
  ));
}

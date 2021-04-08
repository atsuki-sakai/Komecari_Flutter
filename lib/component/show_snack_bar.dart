import 'package:flutter/material.dart';

Future<void> showSnackBar(BuildContext context,
    {@required Widget content, int hideSec, Color color}) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: content,
    duration: Duration(seconds: hideSec ?? 3),
    backgroundColor: color ?? Colors.grey.shade700,
  ));
}

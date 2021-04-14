import 'package:flutter/material.dart';
import 'package:komecari_project/component/custom_text/title_text.dart';

Widget buildTransparentAppBar({
  bool showIcon = false,
  String title,
  Color color = Colors.white,
  List<Widget> actions,
  Widget leading,
}) {
  return AppBar(
    shadowColor: Colors.transparent,
    backgroundColor: color,
    leading: leading,
    actions: actions,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showIcon) ...{
          Icon(Icons.rice_bowl_outlined),
        },
        SizedBox(
          width: 12.0,
        ),
        TitleText(
          text: title,
        ),
        SizedBox(
          //icon有りと無しでcenterの位置がずれている為。
          width: showIcon == true ? 12.0 : 60.0,
        ),
        if (showIcon) ...{
          Opacity(
            opacity: 0.0,
            child: Icon(Icons.rice_bowl_outlined),
          ),
        }
      ],
    ),
  );
}

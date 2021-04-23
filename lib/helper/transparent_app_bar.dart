import 'package:flutter/material.dart';
import 'package:komecari_project/component/custom_text/title_text.dart';

class TransParentAppBar extends StatelessWidget with PreferredSizeWidget {

  const TransParentAppBar({
    this.showIcon = false,
    required this.title,
    this.color = Colors.white,
    this.actions,
    this.leading,
  });

  final bool showIcon;
  final String title;
  final Color color;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Size get preferredSize => Size(double.infinity, 40);

  @override
  Widget build(BuildContext context) {
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
}

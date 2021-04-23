import 'package:flutter/material.dart';
import 'custom_text/title_text.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar(
      {Key? key,
      this.shwoDefaultBackbutton = true,
      this.showMenuButton = false,
      this.actions,
      })
      : super(key: key);
  final bool shwoDefaultBackbutton;
  final bool showMenuButton;
  final List<Widget>? actions;

  @override
  Size get preferredSize => Size(double.infinity, 40);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: shwoDefaultBackbutton
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_outlined),
            )
          : SizedBox(),
      title: _buildAppBarTitle(),
      shadowColor: Colors.transparent,
      actions: [
        if (showMenuButton) ...{
          IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu))
        },
        if (actions != null) ...{
          ...actions!,
        },
      ],
    );
  }

  Row _buildAppBarTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.rice_bowl_outlined),
        SizedBox(
          width: 12.0,
        ),
        TitleText(
          text: 'KOMECARI',
        ),
        SizedBox(
          width: 12.0,
        ),
        Opacity(
          opacity: 0.0,
          child: Icon(Icons.rice_bowl_outlined),
        ),
      ],
    );
  }
}

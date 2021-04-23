import 'package:flutter/material.dart';

class SafeScaffold extends StatelessWidget {
  SafeScaffold({
    this.appBar,
    this.drawer,
    this.floatingActionButton,
    this.body,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
    this.bottomNavigationBar,
    this.backGroundColor = Colors.white,
    this.alignment = Alignment.center,
  });

  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final FloatingActionButton? floatingActionButton;
  final BottomNavigationBar? bottomNavigationBar;
  final Color backGroundColor;
  final EdgeInsets padding;
  final Alignment alignment;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: Container(
          alignment: alignment,
          padding: padding,
          child: body,
        ),
      ),
    );
  }
}

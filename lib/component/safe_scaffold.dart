import 'package:flutter/material.dart';

class SafeScaffold extends StatelessWidget {
  SafeScaffold({
    this.appBar,
    this.drawer,
    this.floatingActionButton,
    this.body,
    this.padding,
    this.bottomNavigationBar,
    this.backGroundColor = Colors.white,
  });

  final Widget body;
  final Widget appBar;
  final Widget drawer;
  final FloatingActionButton floatingActionButton;
  final BottomNavigationBar bottomNavigationBar;
  final Color backGroundColor;
  final EdgeInsets padding;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
          child: body,
        ),
      ),
    );
  }
}

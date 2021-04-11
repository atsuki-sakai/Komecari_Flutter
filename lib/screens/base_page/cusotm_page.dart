import 'package:flutter/material.dart';
import 'dart:async';
import 'package:komecari_project/screens/home_page/home_page.dart';
import 'package:komecari_project/screens/rices_page/rice_page.dart';
import 'package:komecari_project/screens/search_rice_page/search_rice.dart';

class CustomPageView extends StatefulWidget {
  @override
  _CustomPageViewState createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {

  final List<Widget> _pages = [HomePage(), RicePage(), SearchRicePage()];
  final _pageController = PageController();
  CustomPageBloc bloc = CustomPageBloc();
 
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.customPageStateStream,
        builder: (context, snapShot) {
          return PageView(
            children: _pages,
            controller: _pageController,
            onPageChanged: bloc.changeState,
          );
        });
  }
}

class CustomPageBloc {
  final StreamController<int> _customPageStreamController =
      StreamController<int>();
  Stream<int> get customPageStateStream => _customPageStreamController.stream;
  Sink<int> get _changeStateSink => _customPageStreamController.sink;

  void changeState(int index) {
    _changeStateSink.add(index);
  }

  void dispose() {
    _customPageStreamController.close();
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class BasePageBloc {
  final _pageStateSubject = BehaviorSubject<int>.seeded(0);
  Stream<int> get currentPageStateStream => _pageStateSubject.stream;
  Sink<int> get _pageState => _pageStateSubject.sink;
  
  final pageController = PageController();
  int get currentIndex => _pageStateSubject.value!;

  void dispose() {
    _pageStateSubject.close();
    pageController.dispose();
  }

  void changeCurrentIndex(int index) {
    pageController.animateToPage(index, duration: Duration(milliseconds: 120), curve: Curves.easeInOut);
    _pageState.add(index);
  }
}

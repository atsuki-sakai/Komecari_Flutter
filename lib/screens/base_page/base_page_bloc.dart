import 'dart:async';

class BasePageBloc {
  final StreamController<int> _navStateController = StreamController<int>();
  Stream<int> get currentPageStateStream => _navStateController.stream;
  Sink<int> get changePageSink => _navStateController.sink;

  void dispose() {
    _navStateController.close();
  }

  void changeCurrentIndex(int index) {
    changePageSink.add(index);
  }
}

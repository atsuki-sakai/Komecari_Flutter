import 'package:flutter/material.dart';

class APIPath {
  static String user({@required String userId}) => 'users/$userId';

  static String rice({@required String riceId}) => 'rices/$riceId';
}

class StoragePath {
  static String profile({@required String userId}) => 'Profiles/$userId';
  static String rice({@required String riceId}) => 'Rices/$riceId';
}

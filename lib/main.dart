import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:komecari_project/screens/base_page/base_page.dart';
import 'package:komecari_project/screens/other/error_page.dart';
import 'package:komecari_project/screens/other/loading_page.dart';
import 'package:komecari_project/service/komecari_user_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buidThemeData(),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapShot) {
          if (snapShot.hasError) return ExceptionErrorPage();
          if (snapShot.connectionState == ConnectionState.done) {
            // REVIWE: _initializationと同じ場所で初期化した場合クラッシュする。
            return BasePage(komecariService: KomecariUserService());
          }
          return LoadingPage();
        },
      ),
    );
  }

  ThemeData _buidThemeData() {
    return ThemeData(
      primaryColor: Colors.white,
    );
  }
}

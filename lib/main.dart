import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:komecari_project/screens/base_page/base_page.dart';
import 'package:komecari_project/screens/other/error_page.dart';
import 'package:komecari_project/screens/other/loading_page.dart';

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
            return BasePage.launchProviders(context);
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

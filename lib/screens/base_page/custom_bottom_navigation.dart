import 'package:flutter/material.dart';
import 'package:komecari_project/screens/base_page/base_page_bloc.dart';

// class CustomBottomNavigationBar extends StatelessWidget {
//   final bloc = BasePageBloc();
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<int>(
//         stream: bloc.bottomNavStateStream,
//         builder: (context, snapShot) {
//           final _currentIndex = snapShot.data;
//           print('current index =>  $_currentIndex');
//           return BottomNavigationBar(
//             currentIndex: _currentIndex ?? 0,
//             items: [
//               BottomNavigationBarItem(
//                 label: 'Home',
//                 icon: Icon(Icons.home),
//               ),
//               BottomNavigationBarItem(
//                 label: 'Rice',
//                 icon: Icon(Icons.rice_bowl),
//               ),
//               BottomNavigationBarItem(
//                 label: 'Search',
//                 icon: Icon(Icons.search),
//               ),
//             ],
//             onTap: bloc.changeCurrentIndex,
//           );
//         });
//   }
// }

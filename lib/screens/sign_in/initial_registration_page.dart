// import 'package:flutter/material.dart';
// import 'package:komecari_project/component/alert_dialog.dart';
// import 'package:komecari_project/component/custom_text/title_text.dart';
// import 'package:komecari_project/component/safe_scaffold.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:komecari_project/screens/sign_in/sign_in_bloc.dart';
// import 'package:komecari_project/screens/sign_in/sign_in_model.dart';
// import 'package:komecari_project/service/komecari_user_service.dart';
// import 'package:provider/provider.dart';
//
// class InitialRegistrationPage extends StatefulWidget {
//
//   static Widget create(BuildContext context, KomecariUserService komecariService) {
//     return Provider(
//       create: (_) => SignInBloc(komecariService: komecariService),
//       child: Consumer<SignInBloc>(
//         builder: (_, bloc, __) {
//           return
//         },
//       ),
//     );
//   }
//   @override
//   _InitialRegistrationPageState createState() =>
//       _InitialRegistrationPageState();
// }
//
// class _InitialRegistrationPageState extends State<InitialRegistrationPage> {
//   File _image;
//   final picker = ImagePicker();
//
//   Future<void> showCamera() async {
//     final pickerFile = await picker.getImage(source: ImageSource.camera);
//
//     setState(() {
//       if (pickerFile != null) {
//         _image = File(pickerFile.path);
//       } else {
//         print('no select image');
//       }
//     });
//   }
//
//   Future<void> showGallery() async {
//     final pickerFile = await picker.getImage(source: ImageSource.gallery);
//
//     setState(() {
//       if (pickerFile != null) {
//         _image = File(pickerFile.path);
//         print(_image.path);
//       } else {
//         print('no select image');
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeScaffold(
//       appBar: PreferredSize(
//           preferredSize: Size(double.infinity, 60),
//           child: _buildCustomAppBar(context)),
//       body: Column(children: [
//         Text('アカウントタイプを選択'),
//
//       ],),
//     );
//   }
//
//   Row _buildSelectAccountTypeSwitch({SignInModel model}) {
//     return Row(
//       children: [
//         Icon(
//           model.isSeller ? Icons.check_circle_outline : Icons.cancel_outlined,
//           color: model.isSeller ? Colors.green.shade300 : Colors.red.shade300,
//           size: 32,
//         ),
//         SizedBox(
//           width: 12.0,
//         ),
//         TitleText(
//           text: model.isSeller ? 'お米を出品する。' : 'お米を出品しない。',
//           fontSize: 18.0,
//           color: model.isSeller ? Colors.blue.shade300 : Colors.grey.shade400,
//         ),
//         Spacer(),
//         Switch(
//           value: model.isSeller,
//           onChanged: (value) {
//             setState(() {
//               model.isSeller = value;
//             });
//           },
//         ),
//       ],
//     );
//
//   Widget _buildCustomAppBar(BuildContext context,
//       {bool defaultBackButton = true, List<Widget> actions}) {
//     return AppBar(
//       leading: defaultBackButton
//           ? IconButton(
//         onPressed: () {
//           Navigator.pop(context);
//         },
//         icon: Icon(Icons.arrow_back_ios_outlined),
//       )
//           : SizedBox(),
//       title: _buildAppBarTitle(),
//       shadowColor: Colors.transparent,
//       actions: actions ?? actions,
//     );
//   }
//
//   Row _buildAppBarTitle() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(Icons.rice_bowl_outlined),
//         SizedBox(
//           width: 12.0,
//         ),
//         TitleText(
//           text: 'KOMECARI',
//         ),
//         SizedBox(
//           width: 12.0,
//         ),
//         Opacity(
//           opacity: 0.0,
//           child: Icon(Icons.rice_bowl_outlined),
//         ),
//       ],
//     );
//   }
// }
//
// ///
// /// SafeScaffold(
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () async {
// //           final selectType = await showAlertDialog(
// //             context,
// //             title: 'Profile画像を選択',
// //             content: 'プロフィール画像を選択します。設定しない場合は初期画像が選択されます。',
// //             defaultActionText: 'カメラを起動',
// //             cancelActionText: 'アルバムを開く',
// //           );
// //           if (selectType) {
// //             showCamera();
// //           } else {
// //             showGallery();
// //           }
// //           // showGallery();
// //         },
// //         child: Icon(Icons.add_a_photo_outlined),
// //       ),
// //       body: Center(
// //         child: _image == null ? Text('No image selected.') : SizedBox(
// //           width: 220, height: 220, child: ClipRRect(borderRadius: BorderRadius.circular(120),child: Image.file(_image, fit: BoxFit.fill,)),),
// //       ),
// //     )
// ///

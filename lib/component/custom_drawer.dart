import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:komecari_project/model/komecari_user.dart';
import 'package:komecari_project/screens/sign_in/sign_in_page.dart';
import 'package:komecari_project/service/komecari_user_service.dart';
import 'custom_text/title_text.dart';

final loginMenuItems = [
  DrawerMenuItem(
    title: 'プロフィール',
    iconData: Icons.person_outline,
  ),
  DrawerMenuItem(title: 'お気に入り農家', iconData: Icons.favorite_outline),
  DrawerMenuItem(
    title: 'fsdfas',
    iconData: Icons.person_outline,
  ),
  DrawerMenuItem(title: 'おfsdfa', iconData: Icons.favorite_outline),
];

final defaultMenuItems = [
  DrawerMenuItem(
    title: 'サインイン',
    iconData: Icons.person_outline,
  ),
  DrawerMenuItem(
    title: 'プロフィール',
    iconData: Icons.person_outline,
  ),
  DrawerMenuItem(title: 'お気に入り農家', iconData: Icons.favorite_outline),
  DrawerMenuItem(
    title: 'プロフィール',
    iconData: Icons.person_outline,
  ),
  DrawerMenuItem(title: 'お気に入り農家', iconData: Icons.favorite_outline),
];

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key key, this.komecariUser, this.komecariService})
      : super(key: key);

  final KomecariUser komecariUser;
  final KomecariUserService komecariService;

  @override
  Drawer build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      child: ListView.separated(
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildLoginHeader(context);
            }
            return ListTile(
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
              ),
              leading: Icon(komecariUser != null
                  ? loginMenuItems[index - 1].iconData
                  : defaultMenuItems[index - 1].iconData),
              title: Text(komecariUser != null
                  ? loginMenuItems[index - 1].title
                  : defaultMenuItems[index - 1].title),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SignInPage(komecariService: komecariService);
                }));
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              thickness: index == 0 ? 0.0 : 3,
              indent: 12,
              endIndent: 12,
            );
          },
          itemCount: komecariUser != null
              ? loginMenuItems.length + 1
              : defaultMenuItems.length + 1),
    );
  }

  Container _buildLoginHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade400,
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: komecariUser.prifileImageUrl != null
                          ? Image.network(komecariUser.prifileImageUrl)
                          : Text('null')),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildKomecariLogo(),
                  SizedBox(
                    height: 14.0,
                  ),
                  TitleText(
                    text: komecariUser.userName,
                    fontSize: 18.0,
                  ),
                  Text(
                    komecariUser.email,
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                ],
              ),
            ],
          ),
          if(!komecariUser.isSeller)...{
            Text('お米を出品してみませんか？')
          }
        ],
      ),
    );
  }

  Row _buildKomecariLogo() {
    return Row(
                  children: [
                    Icon(Icons.rice_bowl_outlined),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      'KOMECARI.',
                      style: GoogleFonts.notoSans(),
                    ),
                  ],
                );
  }
}

///
/// Center(
//                           child: Text(
//                             'No Image',
//                             style:
//                                 TextStyle(color: Colors.white, fontSize: 14.0),
//                           ),
//                         )
///

class DrawerMenuItem {
  DrawerMenuItem({this.title, this.iconData});

  final String title;
  final IconData iconData;
}

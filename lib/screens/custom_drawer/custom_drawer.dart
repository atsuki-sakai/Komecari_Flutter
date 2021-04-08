import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:komecari_project/component/custom_text/description_text.dart';
import 'package:komecari_project/model/komecari_user.dart';
import 'package:komecari_project/screens/sign_in/sign_in_page.dart';
import 'package:komecari_project/service/komecari_user_service.dart';
import '../../component/custom_text/title_text.dart';

// FIXME - indexを必要としない使用に変更する　indexを揃えないとonTap
final buyerMenuItems = [
  DrawerMenuItem(
    index: 0,
    title: 'プロフィール',
    iconData: Icons.person,
  ),
  DrawerMenuItem(index: 1, title: '購入履歴', iconData: Icons.list_alt),
  DrawerMenuItem(index: 2, title: 'お気に入り農家', iconData: Icons.favorite),
  DrawerMenuItem(index: 3, title: 'カート', iconData: Icons.shopping_cart),
  DrawerMenuItem(index: 4, title: '設定', iconData: Icons.settings),
];

final sellerMenuItems = [
  DrawerMenuItem(
    index: 0,
    title: 'プロフィール',
    iconData: Icons.person,
  ),
  DrawerMenuItem(index: 1, title: '出品する', iconData: Icons.add_business),
  DrawerMenuItem(index: 2, title: '購入履歴', iconData: Icons.list_alt),
  DrawerMenuItem(index: 3, title: 'お気に入り農家', iconData: Icons.favorite),
  DrawerMenuItem(index: 4, title: 'カート', iconData: Icons.shopping_cart),
  DrawerMenuItem(index: 5, title: '設定', iconData: Icons.settings),
  DrawerMenuItem(index: 6, title: '出品中の商品', iconData: Icons.storefront),
  DrawerMenuItem(index: 7, title: '販売履歴', iconData: Icons.history_edu),
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
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Column(
              children: [
                _buildLoginHeader(context, komecariUser),
                SizedBox(
                  height: 12,
                ),
                if (komecariUser == null) ...{
                  Icon(
                    Icons.list_alt_outlined,
                    color: Colors.green.shade400,
                    size: 50,
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  DescriptionText(
                    text: 'ログインするとダッシュボードが\n表示されます。',
                    fontSize: 15.0,
                  ),
                } else ...{
                  if (komecariUser.isSeller) ...{
                    Text(
                      'Menu',
                      style: GoogleFonts.montserrat(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    for (var menuItem in sellerMenuItems) ...{
                      ListTile(
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                        ),
                        title: Text(
                          menuItem.title,
                          style: GoogleFonts.notoSans(
                              fontSize: 18.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                        ),
                        leading: Icon(
                          menuItem.iconData,
                          color: Colors.blue.shade500,
                        ),
                        onTap: () {
                          print(menuItem.title);
                        },
                      ),
                    }
                  } else ...{
                    Text(
                      'Menu',
                      style: GoogleFonts.montserrat(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    for (var menuItem in buyerMenuItems) ...{
                      ListTile(
                        trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          menuItem.title,
                          style: GoogleFonts.notoSans(
                              fontSize: 18.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                        ),
                        leading: Icon(
                          menuItem.iconData,
                          color: Colors.blue.shade500,
                        ),
                        onTap: () {
                          print(menuItem.index);
                        },
                      ),
                    }
                  }
                },
                SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey.shade400,
                  endIndent: 62,
                  indent: 62,
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () async {
                    if (komecariUser == null) {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SignInPage(komecariService: komecariService);
                      }));
                    } else {
                      await Future.delayed(Duration(seconds: 1));
                      Navigator.pop(context);
                      await komecariService.logOut(uid: komecariUser.uid);
                    }
                  },
                  child: Text(
                    komecariUser == null ? 'Log In' : 'Sign Out',
                    style: GoogleFonts.montserrat(
                        fontSize: 18.0,
                        color: Colors.blue.shade500,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildLoginHeader(BuildContext context, KomecariUser user) {
    if (user != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: Column(
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
                      color: Colors.blueGrey,
                      border: Border.all(color: Colors.grey.shade500, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        user.prifileImageUrl ??
                            Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: Colors.white,
                                size: 42,
                              ),
                            ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildKomecariLogo(),
                      SizedBox(
                        height: 14.0,
                      ),
                      TitleText(
                        text: user.userName,
                        fontSize: 16.0,
                      ),
                      Text(
                        user.email,
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
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
                      color: Colors.blueGrey,
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildKomecariLogo(),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'ようこそ \nKomecariへ',
                        style: GoogleFonts.montserrat(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Row _buildKomecariLogo() {
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        Icon(Icons.rice_bowl_outlined),
        SizedBox(
          width: 6,
        ),
        Text(
          'KOMECARI.',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class DrawerMenuItem {
  DrawerMenuItem({this.index, this.title, this.iconData});
  final int index;
  final String title;
  final IconData iconData;
}

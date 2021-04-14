import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:komecari_project/component/custom_text/description_text.dart';
import 'package:komecari_project/model/komecari_user.dart';
import 'package:komecari_project/screens/add_rice_page/add_rice_page.dart';
import 'package:komecari_project/screens/cart_page/cart.dart';
import 'package:komecari_project/screens/favorite_page/fafvorite_page.dart';
import 'package:komecari_project/screens/onsale_rices_page/onsale_rices_page.dart';
import 'package:komecari_project/screens/profile_page/profile_page.dart';
import 'package:komecari_project/screens/purchased_history/purchased_history_page.dart';
import 'package:komecari_project/screens/sale_history_page/sale_history_page.dart';
import 'package:komecari_project/screens/setting_page/setting_page.dart';
import 'package:komecari_project/screens/sign_in/sign_in_page.dart';
import 'package:komecari_project/service/komecari_user_service.dart';
import '../../component/custom_text/title_text.dart';

final buyerMenuItems = [
  DrawerMenuItem(
    title: 'プロフィール',
    iconData: Icons.person,
  ),
  DrawerMenuItem(title: '購入履歴', iconData: Icons.list_alt),
  DrawerMenuItem(title: 'お気に入り農家', iconData: Icons.favorite),
  DrawerMenuItem(title: 'カート', iconData: Icons.shopping_cart),
  DrawerMenuItem(title: '設定', iconData: Icons.settings),
];

final sellerMenuItems = [
  DrawerMenuItem(
    title: 'プロフィール',
    iconData: Icons.person,
  ),
  DrawerMenuItem(title: '出品する', iconData: Icons.add_business),
  DrawerMenuItem(title: '購入履歴', iconData: Icons.list_alt),
  DrawerMenuItem(title: 'お気に入り農家', iconData: Icons.favorite),
  DrawerMenuItem(title: 'カート', iconData: Icons.shopping_cart),
  DrawerMenuItem(title: '設定', iconData: Icons.settings),
  DrawerMenuItem(title: '出品中の商品', iconData: Icons.storefront),
  DrawerMenuItem(title: '販売履歴', iconData: Icons.history_edu),
];

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key key, this.komecariUser, this.komecariService})
      : super(key: key);

  final KomecariUser komecariUser;
  final KomecariUserService komecariService;

  void _loginAndHideDrawer(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SignInPage(komecariService: komecariService);
    }));
  }

  Widget _transitionMenuPage(DrawerMenuItem menuItem) {
    switch (menuItem.title) {
      case 'プロフィール':
        return ProfilePage();
        break;
      case '購入履歴':
        return PurchasedHistoryPage();
        break;
      case 'お気に入り農家':
        return FavoriteFamerPage();
        break;
      case 'カート':
        return CartPage();
        break;
      case '設定':
        return SettingPage();
        break;
      case '出品する':
        return AddRicePage(user: komecariUser,);
        break;
      case '出品中の商品':
        return OnSaleRicesPage();
        break;
      case '販売履歴':
        return SaleHistoryPage();
        break;
    }
  }

  Future<void> _logoutAndHideDrawer(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.pop(context);
    await komecariService.logOut(uid: komecariUser.uid);
  }

  @override
  Drawer build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Column(
              children: [
                _buildHeader(context, komecariUser),
                SizedBox(
                  height: 12,
                ),
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
                if (komecariUser == null) ...{
                  ...notLoginMenu()
                } else ...{
                  ..._buildMenuItems(onTap: (menuItem)  {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return _transitionMenuPage(menuItem);
                    }));
                  })
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
                _buildLoginAndLogoutButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton _buildLoginAndLogoutButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (komecariUser == null) {
          _loginAndHideDrawer(context);
        } else {
          _logoutAndHideDrawer(context);
        }
      },
      child: Text(
        komecariUser == null ? 'Log In' : 'Sign Out',
        style: GoogleFonts.montserrat(
            fontSize: 22.0,
            color: Colors.blue.shade500,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  List<Widget> notLoginMenu() {
    return [
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
    ];
  }

  List<Widget> _buildMenuItems({@required Function(DrawerMenuItem) onTap}) {
    return [
      if (komecariUser.isSeller) ...{
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
                  fontWeight: FontWeight.w400),
            ),
            leading: Icon(
              menuItem.iconData,
              color: Colors.blue.shade500,
            ),
            onTap: () {
              onTap(menuItem);
            },
          ),
        }
      } else ...{
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
              onTap(menuItem);
            },
          ),
        }
      }
    ];
  }

  Container _buildHeader(BuildContext context, KomecariUser user) {
    if (user != null) {
      return _buildLoginHeader(user);
    } else {
      return _buildNotLoginHeader();
    }
  }

  Container _buildLoginHeader(KomecariUser user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildUserIcon(user: user),
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
                SizedBox(
                  height: 4,
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
    );
  }

  SizedBox _buildUserIcon({@required KomecariUser user}) {
    return SizedBox(
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
    );
  }

  Container _buildNotLoginHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30.0,
          ),
          Text(
            'ようこそ \nKomecariへ',
            style: GoogleFonts.montserrat(
                fontSize: 28.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildKomecariLogo() {
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        Icon(Icons.rice_bowl_outlined),
        SizedBox(
          width: 4,
        ),
        Text(
          'KOMECARI',
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:komecari_project/component/custom_text/description_text.dart';
import 'package:komecari_project/model/drawer_menu_item.dart';
import 'package:komecari_project/model/komecari_user.dart';
import 'package:komecari_project/screens/add_rice_page/add_rice_page.dart';
import 'package:komecari_project/screens/base_page/base_page.dart';
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
  const CustomDrawer(
      {Key? key, required this.komecariService})
      : super(key: key);
  final KomecariUserService komecariService;

  void _transitionLoginPage(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SignInPage(komecariService: komecariService);
    }));
  }

  Widget _presentPage(BuildContext context,
      {required DrawerMenuItem menuItem,required KomecariUser? user}) {
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
        return AddRicePage.create(context, user: user!);
        break;
      case '出品中の商品':
        return OnSaleRicesPage();
        break;
      case '販売履歴':
        return SaleHistoryPage();
      default:
        return BasePage.launchProviders(context);
    }
  }

  Future<void> _logoutAndHideDrawer(BuildContext context, KomecariUser user) async {
    await Future.delayed(Duration(seconds: 1));
    await komecariService.logOut(uid: user.uid);
    Navigator.pop(context);
  }

  @override
  Drawer build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: StreamBuilder<KomecariUser?>(
              stream: komecariService.userStream,
              builder: (context, snapshot) {
                final KomecariUser? user = snapshot.data;
                return Column(
                  children: [
                    _buildHeader(context, user: user),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      user != null ? 'Menu' : '',
                      style: GoogleFonts.montserrat(
                          fontSize: user != null ? 20.0 : 16.0,
                          fontWeight: FontWeight.bold,
                          color: user != null
                              ? Colors.black87
                              : Colors.blue.shade500),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    if (user == null) ...{
                      ...notLoginMenu()
                    } else ...{
                      ..._buildMenuItems(user: user, onTap: (menuItem) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return _presentPage(context, menuItem: menuItem, user: user);
                        }));
                      })
                    },
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.grey.shade400,
                      endIndent: 100,
                      indent: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buildLoginAndLogoutButton(context, user),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildLoginAndLogoutButton(BuildContext context, KomecariUser? user) {
    return ElevatedButton.icon(
      icon: Icon(user == null ? Icons.login_outlined : Icons.logout),
      style: ElevatedButton.styleFrom(
        primary: Colors.indigoAccent,
        padding: const EdgeInsets.all(8),
      ),
      onPressed: () async {
        if (user == null) {
          _transitionLoginPage(context);
        } else {
          _logoutAndHideDrawer(context, user);
        }
      },
      label: Text(
        user == null ? 'SignIn & SignUp' : 'Sign Out',
        style: GoogleFonts.montserrat(
            fontSize: 22.0,
            color: Colors.white,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  List<Widget> notLoginMenu() {
    return [
      Icon(
        Icons.list_alt_outlined,
        color: Colors.green.shade400,
        size: 80,
      ),
      SizedBox(
        height: 12.0,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: DescriptionText(
          maxLine:4,
          text: 'ログインするとダッシュボードが表示されます。アカウントの登録と作成をされる方は、下記のボタンから可能です。',
          fontSize: 15.0,
        ),
      ),
    ];
  }

  List<Widget> _buildMenuItems({required Function(DrawerMenuItem) onTap, required KomecariUser user}) {
    return [
      if (user.isSeller) ...{
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
              color: Colors.indigoAccent,
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
              color: Colors.indigoAccent,
            ),
            onTap: () {
              onTap(menuItem);
            },
          ),
        }
      }
    ];
  }

  Container _buildHeader(BuildContext context,{required KomecariUser? user}) {
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

  SizedBox _buildUserIcon({required KomecariUser user}) {
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
          child: user.prifileImageUrl != null
              ? Image.network(user.prifileImageUrl!)
              : Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.white,
                    size: 42,
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
          Text.rich(
            TextSpan(children: [
              TextSpan(
                text: 'ようこそ\n',
                style: GoogleFonts.notoSans(
                    fontSize: 26.0, fontWeight: FontWeight.w400, color: Colors.black87),
              ),
              TextSpan(
                text: 'Komecari',
                style: GoogleFonts.montserrat(
                    fontSize: 28.0, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'へ',
                style: GoogleFonts.notoSans(
                    fontSize: 26.0, fontWeight: FontWeight.w400),
              ),
            ]),
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

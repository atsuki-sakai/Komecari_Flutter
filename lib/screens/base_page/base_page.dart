import 'package:flutter/material.dart';
import 'package:komecari_project/component/custom_app_bar.dart';
import 'package:komecari_project/helper/transparent_app_bar.dart';
import 'package:komecari_project/screens/custom_drawer/custom_drawer.dart';
import 'package:komecari_project/component/custom_text/title_text.dart';
import 'package:komecari_project/model/komecari_user.dart';
import 'package:komecari_project/screens/base_page/base_page_bloc.dart';
import 'package:komecari_project/screens/home_page/home_page.dart';
import 'package:komecari_project/screens/rices_page/rice_page.dart';
import 'package:komecari_project/screens/search_rice_page/search_rice.dart';
import 'package:komecari_project/service/komecari_user_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

const List<BottomNavigationBarItem> _navigationItems = [
  BottomNavigationBarItem(
    label: 'Home',
    icon: Icon(Icons.home),
  ),
  BottomNavigationBarItem(
    label: 'Rice',
    icon: Icon(Icons.rice_bowl),
  ),
  BottomNavigationBarItem(
    label: 'Search',
    icon: Icon(Icons.search),
  ),
];

class BasePage extends StatefulWidget {

  static Widget launchProviders(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BasePageBloc>(
          create: (_) => BasePageBloc(),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        Provider<KomecariUserService>(
          create: (_) => KomecariUserService(),
          dispose: (_, bloc) => bloc.dispose(),
        ),
      ],
      child: BasePage(),
    );
  }

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final _pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void changeCurrentPage(int index) {
    final bloc = Provider.of<BasePageBloc>(context, listen: false);
    bloc.changeCurrentIndex(index);
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 200),
      curve: Curves.ease,
    );
  }

  List<Widget> pagesAddKomecariService(BuildContext context) {
    final _service = Provider.of<KomecariUserService>(context);
    return [HomePage(komecariService: _service,), RicePage(komecariService: _service,), SearchRicePage(komecariService: _service,)];
  }


  Widget build(BuildContext context) {
    final bloc = Provider.of<BasePageBloc>(context, listen: false);
    final komecariService =
        Provider.of<KomecariUserService>(context, listen: false);
    return StreamBuilder<int>(
      stream: bloc.currentPageStateStream,
      builder: (context, snapshot) {
        final currentIndex = snapshot.data ?? 0;
        return Scaffold(
          appBar: CustomAppBar(
            shwoDefaultBackbutton: false,
            showMenuButton: true,
          ),
          drawer: StreamBuilder<KomecariUser>(
              stream: komecariService.userStream,
              builder: (context, snapshot) {
                final komecariUser = snapshot.data;
                return CustomDrawer(
                  komecariUser: komecariUser,
                  komecariService: komecariService,
                );
              }),
          body: PageView(
            controller: _pageController,
            children: pagesAddKomecariService(context),
            onPageChanged: bloc.changeCurrentIndex,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            items: _navigationItems,
            onTap: changeCurrentPage,
          ),
        );
      },
    );
  }
}

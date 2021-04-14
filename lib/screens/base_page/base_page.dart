import 'package:flutter/material.dart';
import 'package:komecari_project/helper/transparent_app_bar.dart';
import 'package:komecari_project/screens/custom_drawer/custom_drawer.dart';
import 'package:komecari_project/component/custom_text/title_text.dart';
import 'package:komecari_project/model/komecari_user.dart';
import 'package:komecari_project/screens/base_page/base_page_bloc.dart';
import 'package:komecari_project/screens/home_page/home_page.dart';
import 'package:komecari_project/screens/rices_page/rice_page.dart';
import 'package:komecari_project/screens/search_rice_page/search_rice.dart';
import 'package:komecari_project/service/komecari_user_service.dart';

class BasePage extends StatefulWidget {
  BasePage({Key key, @required this.komecariService}) : super(key: key);
  final KomecariUserService komecariService;
  final List<Widget> _pages = [HomePage(), RicePage(), SearchRicePage()];

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final _pageController = PageController();
  final bloc = BasePageBloc();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void changeCurrentPage(int index) {
    bloc.changeCurrentIndex(index);
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.ease);
  }

  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: bloc.currentPageStateStream,
      builder: (context, snapshot) {
        final currentIndex = snapshot.data ?? 0;
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 60),
            child: buildTransparentAppBar(
              showIcon: true,
              title: 'KOMECARI',
            ),
          ),
          drawer: StreamBuilder<KomecariUser>(
              stream: widget.komecariService.userStream,
              builder: (context, snapshot) {
                final komecariUser = snapshot.data;
                return CustomDrawer(
                  komecariUser: komecariUser,
                  komecariService: widget.komecariService,
                );
              }),
          body: PageView(
            controller: _pageController,
            children: widget._pages,
            onPageChanged: bloc.changeCurrentIndex,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            items: [
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
            ],
            onTap: changeCurrentPage,
          ),
        );
      },
    );
  }
}

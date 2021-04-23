import 'package:flutter/material.dart';
import 'package:komecari_project/component/custom_app_bar.dart';
import 'package:komecari_project/model/komecari_user.dart';
import 'package:komecari_project/screens/custom_drawer/custom_drawer.dart';
import 'package:komecari_project/screens/base_page/base_page_bloc.dart';
import 'package:komecari_project/screens/search_rice_page/search_rice.dart';
import 'package:komecari_project/service/komecari_user_service.dart';
import 'package:provider/provider.dart';

final testDatas = [
  'Hello',
  'Hello',
  'Hello',
  'Hello',
  'Hello',
  'Hello',
  'Hello',
  'Hello',
  'Hello',
  'Hello',
  'Hello',
  'Hello',
  'Hello',
  'Hello',
  'Hello',
];

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
  Widget build(BuildContext context) {
    final bloc = Provider.of<BasePageBloc>(context, listen: false);
    final komecariService =
        Provider.of<KomecariUserService>(context, listen: false);
    return Scaffold(
      appBar: CustomAppBar(
        shwoDefaultBackbutton: false,
        showMenuButton: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        child: Icon(
          Icons.search,
          size: 32,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) {
                return SearchRicePage(komecariService: komecariService);
              }));
        },
      ),
      drawer: CustomDrawer(komecariService: komecariService),
      body: StreamBuilder<KomecariUser?>(
          stream: komecariService.userStream,
          builder: (context, snapshot) {
            final KomecariUser? user = snapshot.data;
            return Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 1200,
                        child: GridView.count(
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          crossAxisCount: 2,
                          children: List.generate(testDatas.length, (index) {
                            return Container(
                              width: 120,
                              height: 120,
                              color: Colors.red,
                              child: Text(testDatas[index]),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

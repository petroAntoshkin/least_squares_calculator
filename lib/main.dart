import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:least_squares/elements/appbar_title.dart';
import 'package:least_squares/elements/my_bottom_nav_bar.dart';
import 'package:least_squares/screens/calculation_page.dart';
import 'package:least_squares/screens/draw_page.dart';
import 'package:least_squares/screens/images_page.dart';
import 'package:least_squares/screens/settings_page.dart';
import 'providers/data_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // print('rebuild main');
    return ChangeNotifierProvider(
      create: (_) => DataProvider(),
      child: Consumer<DataProvider>(
          builder: (context, DataProvider notifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // title: 'Least Squares',
          theme: notifier.theme,
          home: LSMHomePage(),
        );
      }),
    );
  }
}

class LSMHomePage extends StatefulWidget {
  LSMHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LSMHomePageState createState() => _LSMHomePageState();
}

class _LSMHomePageState extends State<LSMHomePage>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // print('rebuild home page');
    ThemeData _themeData = Provider.of<DataProvider>(context).theme;
    _tabController.addListener(() {
      // if(_tabController.indexIsChanging)
      setState(() {});
    });
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: _themeData.backgroundColor,
        appBar: AppBar(
          backgroundColor: _themeData.backgroundColor,
          title: AppbarTitle(
            themeData: _themeData,
          ),
          bottom: TabBar(
            indicatorWeight: 3.0,
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.list)),
              Tab(icon: Icon(Icons.analytics)),
              Tab(icon: Icon(Icons.image)),
              Tab(icon: Icon(Icons.settings_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            CalculationPage(),
            DrawPage(),
            ImagesPage(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: MyBottomNavBar(tabIndex: _tabController.index),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

// import 'package:least_squares/my_translations.dart';
import 'package:least_squares/elements/appbar_title.dart';
import 'package:least_squares/elements/my_bottom_nav_bar.dart';
import 'package:least_squares/screens/calculation_page.dart';
import 'package:least_squares/screens/draw_page.dart';
import 'package:least_squares/screens/images_page.dart';
import 'package:least_squares/screens/settings_page.dart';
import 'providers/data_provider.dart';

import 'package:least_squares/ad_manager.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

// import 'package:material_dialogs/material_dialogs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.initialize();
  MobileAds.setTestDeviceIds(['ca-app-pub-4007582425024550~4028426450']);
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
          // home: MultiProvider(
          //   // providers: [
          //   //   ChangeNotifierProvider(
          //   //       create: (BuildContext context) => DataProvider()),
          //   //   // ChangeNotifierProvider(create: (BuildContext context) => ThemeProvider()),
          //   // ],
          //   child: LSMHomePage(),
          // )
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
  final bannerController = BannerAdController();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);

    bannerController.onEvent.listen((e) {
      final event = e.keys.first;
      print('controller event $e');
      // final info = e.values.first;
      switch (event) {
        case BannerAdEvent.loaded:
        // setState(() => _bannerAdHeight = (info as int)?.toDouble());
          break;
        default:
          break;
      }
    });
    bannerController.load();
  }
  @override
  void dispose() {
    bannerController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // print('rebuild home page');
    ThemeData _themeData = Provider.of<DataProvider>(context).theme;
    _tabController.addListener(() {
      // if(_tabController.indexIsChanging)
      setState(() {});
    });
    final _bannerHeight = 40.0;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: _themeData.backgroundColor,
        appBar: AppBar(
          title: AppbarTitle(),
          bottom: TabBar(
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
        // bottomNavigationBar: BannerAd(controller: bannerController),
        bottomNavigationBar: MyBottomNavBar(
          bannerHeight: _bannerHeight,
            tabIndex: _tabController.index,
            banner: BannerAd(
              unitId: AdManager.bannerAdUnitId,
              controller: bannerController,
              size: BannerSize.fromWH(MediaQuery.of(context).size.width, _bannerHeight),
            )),
      ),
    );
  }
}

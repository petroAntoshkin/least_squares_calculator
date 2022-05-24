import 'package:flutter/material.dart';
import 'package:least_squares/ad_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:least_squares/elements/appbar_title.dart';
import 'package:least_squares/elements/my_bottom_nav_bar.dart';
import 'package:least_squares/screens/calculation_page.dart';
import 'package:least_squares/screens/draw_page.dart';
import 'package:least_squares/screens/images_page.dart';
import 'package:least_squares/screens/settings_page.dart';
import 'providers/data_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

  // Add _bannerAd
  BannerAd _bannerAd;

  // Add _isBannerAdReady
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();

    _tabController = new TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // Dispose a BannerAd object
    _bannerAd.dispose();
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
        bottomNavigationBar: MyBottomNavBar(
          tabIndex: _tabController.index,
          banner: _isBannerAdReady ? AdWidget(ad: _bannerAd)
              :Container(),
          bannerHeight: _isBannerAdReady ? _bannerAd.size.height.toDouble()
          : 54.0,
        ),
      ),
    );
  }
}

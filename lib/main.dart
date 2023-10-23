import 'package:flutter/material.dart';
import 'package:least_squares_calculator/ad_helper.dart';
import 'package:least_squares_calculator/mocks/my_translations.dart';
import 'package:least_squares_calculator/styles_and_presets.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:least_squares_calculator/elements/my_bottom_nav_bar.dart';
import 'package:least_squares_calculator/screens/calculation_page.dart';
import 'package:least_squares_calculator/screens/draw_page.dart';
import 'package:least_squares_calculator/screens/images_page.dart';
import 'package:least_squares_calculator/screens/settings_page.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DataProvider>(
            create: (context) => DataProvider()),
        // ChangeNotifierProvider<FocusProvider>(create: (context) => FocusProvider()),
      ],
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
  LSMHomePage({Key? key, this.title = ''}) : super(key: key);

  final String title;

  @override
  _LSMHomePageState createState() => _LSMHomePageState();
}

class _LSMHomePageState extends State<LSMHomePage>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  late TabController _tabController;

  // Add _bannerAd
  late BannerAd _bannerAd;

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
    _tabController.animation?.addListener(() {
      if (_tabController.previousIndex == 0) {
        Provider.of<DataProvider>(context, listen: false).cancelEditValue();
      }
    });
    _tabController.addListener(() {
      if (_tabController.indexIsChanging && _tabController.previousIndex == 0) {
        Provider.of<DataProvider>(context, listen: false).cancelEditValue();
      }
      Provider.of<DataProvider>(context, listen: false)
          .resetGraphSettingCollapsed();
      setState(() {});
    });
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: _themeData.colorScheme.background,
        appBar: AppBar(
          toolbarHeight: 6.0,
          backgroundColor: _themeData.primaryColorDark,
          // title: AppbarTitle(
          //   themeData: _themeData,
          // ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(Presets.APP_BAR_HEIGHT),
            child: Container(
              color: _themeData.primaryColorLight,
              child: TabBar(
                labelColor: _themeData.focusColor,
                unselectedLabelColor: _themeData.iconTheme.color,
                indicatorWeight: 3.0,
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _themeData.primaryColorDark,
                      _themeData.focusColor,
                    ],
                    stops: [0.95, 1],
                  ),
                ),
                controller: _tabController,
                tabs: [
                  tabColumn(context, Icons.list, 'data'),
                  tabColumn(context, Icons.analytics, 'graph'),
                  tabColumn(context, Icons.save_outlined, 'saved'),
                  tabColumn(context, Icons.settings_outlined, 'settings'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          // physics: NeverScrollableScrollPhysics(),
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
          banner: _isBannerAdReady ? AdWidget(ad: _bannerAd) : Container(),
          bannerHeight: _isBannerAdReady
              ? _bannerAd.size.height.toDouble()
              : Presets.NAV_BAR_HEIGHT,
        ),
      ),
    );
  }

  Widget tabColumn(BuildContext context, IconData iconData, String text) {
    final content = MyTranslations().getLocale(
        Provider.of<DataProvider>(context, listen: false).getLanguage(), text);
    final style = Presets.textSmall;
    final wi = _getTextWidth(context, 'W', style) * content.length;
    final _widIsEnough = wi <= MediaQuery.of(context).size.width / 4;
    // debugPrint(
    //     'text: $content   wid: ${MediaQuery.of(context).size.width / 4},   textWidth: $wi}');
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      height: Presets.APP_BAR_HEIGHT,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Icon(
                iconData,
                size: 30.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: _widIsEnough
                  ? Text(
                    content,
                    style: style,
                  )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      height: Presets.APP_BAR_HEIGHT / 3,
                      child: Marquee(
                        velocity: 20.0,
                        blankSpace: 40.0,
                        text: content,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  double _getTextWidth(BuildContext context, String text, TextStyle style) {
    final span = TextSpan(text: text, style: style);

    final constraints = BoxConstraints(maxWidth: double.infinity);

    final richTextWidget = Text.rich(span).build(context) as RichText;
    final renderObject = richTextWidget.createRenderObject(context);
    renderObject.layout(constraints);

    final boxes = renderObject.getBoxesForSelection(TextSelection(
      baseOffset: 0,
      extentOffset: TextSpan(text: text).toPlainText().length,
    ));

    return boxes.last.right;
  }
}

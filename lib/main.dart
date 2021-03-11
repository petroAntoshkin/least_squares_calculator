import 'package:flutter/material.dart';
import 'package:least_squares/elements/appbar_title.dart';
import 'package:least_squares/elements/bottom_nav_painter.dart';
import 'package:least_squares/mocks/my_translations.dart';

// import 'package:least_squares/my_translations.dart';
import 'package:least_squares/screens/calculation_page.dart';
import 'package:least_squares/screens/draw_page.dart';
import 'package:least_squares/screens/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:ionicons/ionicons.dart';
import 'providers/data_provider.dart';

void main() {
  runApp(MyApp());
}
/// icon generation command:flutter pub run flutter_launcher_icons:main

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print('rebuild main');
    return ChangeNotifierProvider(
      create: (_) => DataProvider(),
      child: Consumer<DataProvider>(
          builder: (context, DataProvider notifier, child) {
        return MaterialApp(
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

class LSMHomePage extends StatelessWidget {
//   LSMHomePage({Key key, this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _LSMHomePageState createState() => _LSMHomePageState();
// }
//
// class _LSMHomePageState extends State<LSMHomePage> {
/*

  void _tabBarController(){

  }

*/

  @override
  Widget build(BuildContext context) {
    print('rebuild home page');
    ThemeData _themeData = Provider.of<DataProvider>(context).theme;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: _themeData.backgroundColor,
        appBar: AppBar(
          title: AppbarTitle(),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Ionicons.list_outline)),
              Tab(icon: Icon(Ionicons.analytics)),
              Tab(icon: Icon(Icons.settings_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CalculationPage(),
            DrawPage(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.08,
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.width * 0.08),
            painter: BottomNavPainter(color: _themeData.primaryColor),
            child: FlatButton(
              onPressed: () => Provider.of<DataProvider>(context, listen: false)
                  .clearAllData(),
              child: Container(
                // color: Colors.green,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.height * 0.07,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: Icon(
                          Icons.cleaning_services,
                          color: _themeData.primaryTextTheme.bodyText1.color,
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(
                        MyTranslations().getLocale(
                            Provider.of<DataProvider>(context).getLocale(),
                            'reset'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _themeData.primaryTextTheme.bodyText1.color,
                        ),
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.height * 0.07,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: Icon(
                          Icons.cleaning_services,
                          color: _themeData.primaryTextTheme.bodyText1.color,)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

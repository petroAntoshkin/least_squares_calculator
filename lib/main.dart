
import 'package:flutter/material.dart';
import 'package:least_squares/localization.dart';
import 'package:least_squares/screens/calculation_page.dart';
import 'package:least_squares/screens/draw_page.dart';
import 'package:least_squares/screens/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:ionicons/ionicons.dart';
import 'data_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Least Squares',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (BuildContext context) => DataProvider()),
        ],
        child: LSMHomePage(),
      )
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

  @override
  Widget build(BuildContext context) {
    String _loc = 'en'; //Localizations.localeOf(context).languageCode;
    // Provider.of<DataProvider>(context).initData(_loc);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(MyLocalization().getLocale(_loc, 'title')),
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
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          tooltip: 'Reset',
          child: Icon(Icons.close),
        ),
      ),
    );
  }
}

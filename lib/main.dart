import 'package:diary_mobile/localization/i18value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './view/SettingsPage.dart';
import './view/LoginPage.dart';
import './view/RegisterPage.dart';
import './view/ProfilePage.dart';
import './view/ConcreteFarmPage.dart';
import './view/ConcreteAnimalPage.dart';

import './localization/localization.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocalStorage storage = new LocalStorage('some_key');

  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLang().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return Container();
    } else {
      return MaterialApp(
        title: 'Diary',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.amber,
          canvasColor: Color.fromRGBO(255, 254, 229, 1),
        ),
        home: MainPage(),
        routes: {
          LoginPage.routeName: (ctx) => LoginPage(),
          RegisterPage.routeName: (ctx) => RegisterPage(),
          ProfilePage.routeName: (ctx) => ProfilePage(),
          SettingPage.routeName: (ctx) => SettingPage(),
          ConctcreteFarm.routeName: (ctx) => ConctcreteFarm(),
          ConcreteAnimal.routeNmae: (ctx) => ConcreteAnimal()
        },
        locale: _locale,
        localeResolutionCallback: (devicelocale, supportedLocales) {
          for (var locale in supportedLocales) {
            if (locale.languageCode == devicelocale.languageCode &&
                locale.countryCode == devicelocale.countryCode) {
              return devicelocale;
            }
          }
          return supportedLocales.first;
        },
        localizationsDelegates: [
          DemoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('uk', 'UA'),
        ],
      );
    }
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();

    checkLoginSatus();
  }

  checkLoginSatus() async {
    sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getString('token') == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => ProfilePage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()),
                    (Route<dynamic> route) => false);
              },
              child: Text('Logout', style: TextStyle(color: Colors.white)))
        ],
      ),
      body: Center(child: Text('Main Page')),
      drawer: Drawer(
          child: new ListView(children: <Widget>[
        new UserAccountsDrawerHeader(
            accountName: new Text('John Doe'),
            accountEmail: new Text('jdoe@gmail.com')),
        new ListTile(
            title: new Text('List Animals'),
            trailing: new Icon(Icons.list),
            onTap: () {}),
        new ListTile(
            title: new Text('Add Animal'),
            trailing: new Icon(Icons.add),
            onTap: () {}),
        new ListTile(
            title: new Text('Register'),
            trailing: new Icon(Icons.add),
            onTap: () {})
      ])),
    );
  }
}

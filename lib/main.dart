import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view/loginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
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
          ]),
      body: Center(child: Text('Main Page')),
      drawer: Drawer(
          child: new ListView(children: <Widget>[
        new UserAccountsDrawerHeader(
            accountName: new Text('Nodejs'),
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

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import './LoginPage.dart';
import './SettingsPage.dart';

class ProfilePage extends StatefulWidget {
  static String routeName = '/profile';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  SharedPreferences sharedPreferences;
  Object userData;
  var result;

  @override
  void initState() {
    super.initState();

    onloadPage();
  }

  void onloadPage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadUserProfile();
  }

  loadUserProfile() async {
    var response = await http.get('https://diary-rest.herokuapp.com/api/auth',
        headers: {"x-auth-token": sharedPreferences.getString('token')});
    result = json.decode(response.body);

    if (result != null) {
      setState(() {
        result = result;
      });
    }

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return Scaffold();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Main', style: TextStyle(color: Colors.white)),
      ),
      body: Center(child: Text('Main Page')),
      drawer: Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text('${result['name']} ${result['surname']}'),
                accountEmail: new Text(result['email'])),
            new ListTile(
              title: new Text('Settings'),
              trailing: new Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).pushNamed(SettingPage.routeName);
              },
            ),
            new ListTile(
                title: new Text('Logout'),
                trailing: new Icon(Icons.exit_to_app),
                onTap: () {
                  sharedPreferences.clear();
                  sharedPreferences.commit();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()),
                      (Route<dynamic> route) => false);
                })
          ],
        ),
      ),
    );
  }
}

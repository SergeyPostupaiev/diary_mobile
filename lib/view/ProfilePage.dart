import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import './LoginPage.dart';
import './SettingsPage.dart';
import '../widgets/farm_card.dart';

class ProfilePage extends StatefulWidget {
  static String routeName = '/profile';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  SharedPreferences sharedPreferences;
  Object userData;
  var profileResult;
  var farmResult;

  @override
  void initState() {
    super.initState();

    onloadPage();
  }

  void onloadPage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await loadUserProfile();

    await loadUserFarms();
  }

  loadUserProfile() async {
    var response = await http.get('https://diary-rest.herokuapp.com/api/auth',
        headers: {"x-auth-token": sharedPreferences.getString('token')});
    profileResult = json.decode(response.body);

    if (profileResult != null) {
      setState(() {
        profileResult = profileResult;
      });
    }

    if (profileResult['msg'] == 'Token is not valid') {
      logout();
    }
  }

  loadUserFarms() async {
    var response = await http.get('https://diary-rest.herokuapp.com/api/farms',
        headers: {"x-auth-token": sharedPreferences.getString('token')});
    farmResult = json.decode(response.body);

    for (var farm in farmResult) {
      var farmAnalysys = await http.get(
          'https://diary-rest.herokuapp.com/api/analysis/farm/${farm['_id']}');

      farm['conditions'] = json.decode(farmAnalysys.body);
    }

    if (farmResult != null) {
      setState(() {
        farmResult = farmResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (profileResult == null || farmResult == null) {
      return Scaffold();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Your Farms', style: TextStyle(color: Colors.white)),
        ),
        body: ListView(
          children: farmResult
              .map<Widget>((item) => FarmCard(
                  id: item['_id'],
                  humidity: item['humidity'].toDouble(),
                  temperature: item['temperature'].toDouble(),
                  name: item['name'],
                  conditions: item['conditions']))
              .toList(),
        ),
        drawer: Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                  accountName: new Text(
                      '${profileResult['name']} ${profileResult['surname']}'),
                  accountEmail: new Text(profileResult['email'])),
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
                  onTap: () => logout())
            ],
          ),
        ),
      );
    }
  }

  logout() {
    sharedPreferences.clear();
    sharedPreferences.commit();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => false);
  }
}

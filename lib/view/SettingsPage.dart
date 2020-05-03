import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

import '../localization/i18value.dart';

class SettingPage extends StatefulWidget {
  static String routeName = '/settings';

  @override
  _SettingPageState createState() => _SettingPageState();
}

enum InterfaceLanguages { en, uk }

class _SettingPageState extends State<SettingPage> {
  SharedPreferences sharedPreferences;

  InterfaceLanguages lang = InterfaceLanguages.en;

  void setLang(InterfaceLanguages value) async {
    Locale localeVar;

    if (value == InterfaceLanguages.en) {
      localeVar = Locale('en', 'US');
      setLanguage('en', 'US');
    }

    if (value == InterfaceLanguages.uk) {
      localeVar = Locale('uk', 'UA');
      setLanguage('uk', 'UA');
    }

    setState(() {
      lang = value;
    });

    MyApp.setLocale(context, localeVar);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    checkCurrentLang();
  }

  checkCurrentLang() async {
    sharedPreferences = await SharedPreferences.getInstance();

    var currLang = sharedPreferences.getString('langCode');

    if (currLang == 'en') {
      setState(() {
        lang = InterfaceLanguages.en;
      });
    } else if (currLang == 'uk') {
      setState(() {
        lang = InterfaceLanguages.uk;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(i18value(context, 'settingsCaption'),
            style: TextStyle(color: Colors.white)),
      ),
      body: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              FlatButton(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Language',
                      style: TextStyle(fontSize: 26),
                    ),
                    SizedBox(height: 10),
                    Text('Choosing the interface language')
                  ],
                ),
                onPressed: () => showAlertDialog(context),
              )
            ],
          )),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Choose the language'),
      content: Container(
        height: 130,
        child: Column(
          children: <Widget>[
            buildRadioButton('English', InterfaceLanguages.en),
            buildRadioButton('Українська', InterfaceLanguages.uk),
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget buildRadioButton(
    String titleText,
    InterfaceLanguages langValue,
  ) {
    return RadioListTile<InterfaceLanguages>(
      title: Text(titleText),
      value: langValue,
      groupValue: lang,
      onChanged: (InterfaceLanguages value) => setLang(value),
      activeColor: Colors.blue,
    );
  }
}

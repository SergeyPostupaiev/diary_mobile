import './localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

String i18value(BuildContext context, String key) {
  return DemoLocalizations.of(context).getValue(key);
}

void setLanguage(String langCode, String countryCode) async {
  SharedPreferences sharedPreferences;

  sharedPreferences = await SharedPreferences.getInstance();

  await sharedPreferences.setString('langCode', langCode);
  await sharedPreferences.setString('countryCode', countryCode);
}

Future<Locale> getLang() async {
  SharedPreferences sharedPreferences;

  sharedPreferences = await SharedPreferences.getInstance();

  String lCode = sharedPreferences.getString('langCode');
  String cCode = sharedPreferences.getString('countryCode');

  if (lCode == null) {
    return Locale('en', 'US');
  }

  return Locale(lCode, cCode);
}

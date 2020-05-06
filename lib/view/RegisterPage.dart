import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../widgets/button_submit.dart';
import '../widgets/register_inputs.dart';
import './LoginPage.dart';
import '../localization/i18value.dart';

class RegisterPage extends StatefulWidget {
  static String routeName = '/login';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController surnameController = new TextEditingController();
  final TextEditingController confirmPasswordController =
      new TextEditingController();

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
        title: Text('Diary'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.language,
            ),
            onPressed: () => showAlertDialog(context),
          )
        ],
      ),
      body: Container(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          i18value(context, 'New_account'),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    RegisterInputs(
                      formSubmit: formSubmit,
                      emailController: emailController,
                      passwordController: passwordController,
                      nameController: nameController,
                      surnameController: surnameController,
                      confirmPasswordController: confirmPasswordController,
                    ),
                    BtnSubmit(
                      formSubmit: formSubmit,
                      btnText: i18value(context, 'get_started'),
                    ),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginPage()),
                                (Route<dynamic> route) => false);
                          },
                          child: Text(
                            i18value(context, 'already_have_acc'),
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }

  getStarted(String email, String password, String name, String surname) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();

    var data = {
      "email": email,
      "password": password,
      "name": name,
      "surname": surname,
    };

    print(data);

    var result = null;

    var response = await http.post('https://diary-rest.herokuapp.com/api/users',
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: json.encode(data));
    result = json.decode(response.body);

    print('Response status: ${response.body}');

    if (result != null) {
      handleRequest(result, sharedPreference);
    } else {
      setState(() {
        _isLoading = false;
      });

      print(response.body);
    }
  }

  void handleRequest(result, SharedPreferences sharedPreference) {
    setState(() {
      _isLoading = false;
    });
    print(result);
    if (result['status'] == 'error') {
      if (result['msg'] is String) {
        showSnackBar(result['msg']);
      }
      if (result['errors'] != null) {
        showSnackBar(result['errors'][0]['msg']);
      }
    } else {
      sharedPreference.setString('token', result['token']);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MainPage()),
          (Route<dynamic> route) => false);
    }
  }

  void showSnackBar(String msg) {
    print(passwordController.text);
    print(emailController.text);

    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      fontSize: 16.0,
    );
  }

  void formSubmit() {
    if (emailController.text == '' ||
        passwordController.text == '' ||
        nameController.text == '' ||
        surnameController.text == '') {
      showSnackBar(i18value(context, 'fill_all_inp'));
    } else if (passwordController.text != confirmPasswordController.text) {
      showSnackBar(i18value(context, 'pass_should_match'));
    } else {
      setState(() {
        _isLoading = true;
      });

      getStarted(
        emailController.text,
        passwordController.text,
        nameController.text,
        surnameController.text,
      );
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(i18value(context, 'lang_choose')),
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

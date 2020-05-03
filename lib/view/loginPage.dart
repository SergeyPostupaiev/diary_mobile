import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../widgets/button_submit.dart';
import '../widgets/login_inputs.dart';
import './RegisterPage.dart';

class LoginPage extends StatefulWidget {
  static String routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
    //     .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      appBar: AppBar(
        title: Text('Diary'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.language,
            ),
            onPressed: () => {},
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
                      height: 150,
                      child: Center(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    LoginInputs(
                      formSubmit: formSubmit,
                      emailController: emailController,
                      passwordController: passwordController,
                    ),
                    BtnSubmit(formSubmit: formSubmit, btnText: 'Sign In'),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        RegisterPage()),
                                (Route<dynamic> route) => false);
                          },
                          child: Text(
                            'Do not have an account?',
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

  signIn(String email, password) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();

    var data = {"email": email, "password": password};

    print(data);

    var result = null;

    var response = await http.post('https://diary-rest.herokuapp.com/api/auth',
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
      setState(() {
        _isLoading = false;
      });

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
    if (emailController.text == '' || passwordController.text == '') {
      showSnackBar('Fill all the inputs, please');
    } else {
      setState(() {
        _isLoading = true;
      });

      signIn(emailController.text, passwordController.text);
    }
  }
}

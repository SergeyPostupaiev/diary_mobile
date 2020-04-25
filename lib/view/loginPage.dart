import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blue, Colors.teal],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView(children: <Widget>[
                    headerSection(),
                    textSection(),
                    buttonSection()
                  ])));
  }

  signIn(String email, password) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    Map data = {"email": "$email", "password": "$password"};

    print(data);

    var result = null;

    var response = await http.post('https://diary-rest.herokuapp.com/api/auth',
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: json.encode({"email": email, "password": password}));
    result = json.decode(response.body);

    print('Response status: ${response.statusCode}');
    print('Response status: ${response.body}');

    if (result != null) {
      setState(() {
        _isLoading = false;
      });

      sharedPreference.setString('token', result['token']);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MainPage()),
          (Route<dynamic> route) => false);
    } else {
      setState(() {
        _isLoading = false;
      });

      print(response.body);
    }
  }

  Container buttonSection() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: RaisedButton(
          onPressed: emailController.text == '' || passwordController.text == ''
              ? null
              : () {
                  setState(() {
                    _isLoading = true;
                  });

                  signIn(emailController.text, passwordController.text);
                },
          elevation: 0.0,
          color: Colors.purple,
          child: Text('Sign In', style: TextStyle(color: Colors.white70)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ));
  }

  Container textSection() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(children: <Widget>[
          TextField(
            controller: emailController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: 'Email',
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 30.0),
          TextField(
            controller: passwordController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: 'Password',
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white),
            ),
          ),
        ]));
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text(
        'Login page',
        style: TextStyle(
            color: Colors.white70, fontSize: 40.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}

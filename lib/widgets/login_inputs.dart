import 'package:flutter/material.dart';

import '../localization/i18value.dart';

class LoginInputs extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function formSubmit;

  LoginInputs({
    this.formSubmit,
    this.emailController,
    this.passwordController,
  });

  @override
  _LoginInputsState createState() => _LoginInputsState();
}

class _LoginInputsState extends State<LoginInputs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: widget.emailController,
            decoration: InputDecoration(
              icon: Icon(Icons.email),
              hintText: i18value(context, 'email'),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.black),
            ),
            onSubmitted: (_) => widget.formSubmit(),
          ),
          SizedBox(height: 30.0),
          TextField(
            obscureText: true,
            controller: widget.passwordController,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              hintText: i18value(context, 'password'),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.black),
            ),
            onSubmitted: (_) => widget.formSubmit(),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../localization/i18value.dart';

class RegisterInputs extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final Function formSubmit;

  RegisterInputs({
    this.formSubmit,
    this.emailController,
    this.passwordController,
    this.nameController,
    this.surnameController,
    this.confirmPasswordController,
  });

  @override
  _RegisterInputsState createState() => _RegisterInputsState();
}

class _RegisterInputsState extends State<RegisterInputs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: widget.nameController,
            decoration: InputDecoration(
              icon: Icon(Icons.account_box),
              hintText: i18value(context, 'first_name'),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.black),
            ),
            onSubmitted: (_) => widget.formSubmit(),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: widget.surnameController,
            decoration: InputDecoration(
              icon: Icon(Icons.account_box),
              hintText: i18value(context, 'last_name'),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.black),
            ),
            onSubmitted: (_) => widget.formSubmit(),
          ),
          SizedBox(height: 20.0),
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
          SizedBox(height: 20.0),
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
          SizedBox(height: 20.0),
          TextField(
            obscureText: true,
            controller: widget.confirmPasswordController,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              hintText: i18value(context, 'confirm_pass'),
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

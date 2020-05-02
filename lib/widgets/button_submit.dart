import 'package:flutter/material.dart';

class BtnSubmit extends StatelessWidget {
  final Function formSubmit;
  final String btnText;

  BtnSubmit({
    @required this.formSubmit,
    @required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      margin: EdgeInsets.symmetric(
        vertical: 20,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: RaisedButton(
        onPressed: () => formSubmit(),
        elevation: 0.0,
        color: Colors.blue,
        child: Text(btnText, style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }
}

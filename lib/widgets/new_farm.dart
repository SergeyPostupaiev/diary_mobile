import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../localization/i18value.dart';

class AddNewFarm extends StatefulWidget {
  final Function addFarm;

  AddNewFarm(this.addFarm);

  @override
  _AddNewFarmState createState() => _AddNewFarmState();
}

class _AddNewFarmState extends State<AddNewFarm> {
  final nameController = TextEditingController();

  submitData() {
    if (nameController.text.isEmpty) {
      showSnackBar(i18value(context, 'fill_all_inp'));

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration:
                  InputDecoration(labelText: i18value(context, 'name_item')),
              controller: nameController,
              onSubmitted: (_) => submitData(),
            ),
            RaisedButton(
              onPressed: submitData,
              child: Text(i18value(context, 'add_animal')),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.button.color,
            )
          ],
        ),
      ),
    );
  }

  void showSnackBar(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      fontSize: 16.0,
    );
  }
}

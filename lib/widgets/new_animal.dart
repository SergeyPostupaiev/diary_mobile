import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../localization/i18value.dart';

class AddNewAnimal extends StatefulWidget {
  @override
  _AddNewAnimalState createState() => _AddNewAnimalState();
}

class _AddNewAnimalState extends State<AddNewAnimal> {
  final nameController = TextEditingController();
  final speciesController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final weightController = TextEditingController();

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
            TextField(
              decoration:
                  InputDecoration(labelText: i18value(context, 'animal_sp')),
              controller: speciesController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              decoration:
                  InputDecoration(labelText: i18value(context, 'age_years')),
              controller: ageController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              decoration:
                  InputDecoration(labelText: i18value(context, 'gender')),
              controller: genderController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              decoration:
                  InputDecoration(labelText: i18value(context, 'weight_kg')),
              controller: weightController,
              keyboardType: TextInputType.number,
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

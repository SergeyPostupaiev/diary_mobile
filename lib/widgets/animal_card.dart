import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/ConcreteAnimalPage.dart';
import '../localization/i18value.dart';

class AnimalCard extends StatelessWidget {
  final String farmId;
  final String state;
  final String name;
  final String species;
  final String gender;
  final int age;
  final double temperature;
  final double weight;
  final String id;
  SharedPreferences sharedPreferences;

  AnimalCard({
    this.id,
    this.farmId,
    this.state,
    this.name,
    this.species,
    this.gender,
    this.age,
    this.temperature,
    this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(i18value(context, 'name_item')),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: <Widget>[
              Text(i18value(context, 'weight_kg')),
              Text(
                '$weight',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: <Widget>[
              Text(i18value(context, 'animal_sp')),
              Text(
                '$species',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: <Widget>[
              Text(i18value(context, 'state_item')),
              Text(
                '$state',
                style: TextStyle(
                    fontSize: 20,
                    color: state == 'regular' ? Colors.green : Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  sharedPreferences = await SharedPreferences.getInstance();
                  sharedPreferences.setString('currentAnimal', id);

                  Navigator.of(context)
                      .pushNamed(ConcreteAnimal.routeNmae, arguments: {
                    'id': id,
                    'name': name,
                    'farmId': farmId,
                    'state': state,
                    'species': species,
                    'gender': gender,
                    'age': age,
                    'temperature': temperature,
                    'weight': weight,
                  });
                },
                child: Icon(
                  Icons.arrow_forward,
                  size: 50,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

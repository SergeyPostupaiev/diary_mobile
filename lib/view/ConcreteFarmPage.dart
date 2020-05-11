import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../widgets/animal_card.dart';
import '../widgets/new_animal.dart';

import '../localization/i18value.dart';

class ConctcreteFarm extends StatefulWidget {
  static String routeName = '/concreteFarm';

  @override
  _ConctcreteFarmState createState() => _ConctcreteFarmState();
}

class _ConctcreteFarmState extends State<ConctcreteFarm> {
  String id;
  SharedPreferences sharedPreferences;
  var farmCond;
  var animals;

  @override
  void initState() {
    super.initState();

    onloadPage();
  }

  void onloadPage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await loadFarmConditions();
  }

  void loadFarmConditions() async {
    final request = http.Request(
      'GET',
      new Uri.https('diary-rest.herokuapp.com', '/api/animals'),
    );

    request.body = json.encode({
      "farmId": sharedPreferences.getString('currentFarm'),
      "stateId": "5ea031b6bb516b57ff1f6ed4",
    });

    request.headers.clear();
    request.headers.addAll({
      "x-auth-token": sharedPreferences.getString('token'),
      HttpHeaders.contentTypeHeader: "application/json"
    });

    animals = await request.send();
    animals = await animals.stream.bytesToString();

    setState(() {
      animals = json.decode(animals);
    });
  }

  pushToAnimals(animalItem) {
    animals.add(animalItem);
  }

  startAddNewAnimal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return GestureDetector(
          onTap: () {},
          child: AddNewAnimal(),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;

    id = routeArgs['id'];
    String name = routeArgs['name'];
    double temperature = routeArgs['temperature'];
    double humidity = routeArgs['humidity'];

    Map<String, dynamic> conditions = routeArgs['conditions'];

    return Scaffold(
      appBar: AppBar(
        title: Text('${name[0].toUpperCase() + name.substring(1)}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () => startAddNewAnimal(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 5000,
          margin: EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 15,
          ),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Text(
                i18value(context, 'f_conditions'),
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    '${i18value(context, 'humidity_s')} $humidity %',
                    style: TextStyle(
                        fontSize: 25,
                        color: defineColor(conditions['humidity']['status'])),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '${conditions['humidity']['response']}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${i18value(context, 'temperature_s')} $temperature °C',
                    style: TextStyle(
                        fontSize: 25,
                        color:
                            defineColor(conditions['temperature']['status'])),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        conditions['temperature']['response'] != null
                            ? '${conditions['temperature']['response']}'
                            : '',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.black),
                ],
              ),
              Text(
                i18value(context, 'animals'),
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 4000,
                child: Scaffold(
                  body: ListView(
                    children: animals != null
                        ? animals
                            .map<Widget>(
                              (item) => AnimalCard(
                                id: item['_id'],
                                name: item['name'],
                                age: item['age'],
                                temperature: item['temperature'].toDouble(),
                                species: item['species'],
                                state: 'regular',
                                farmId: item['farm'],
                                weight: item['weight'].toDouble(),
                                gender: item['gender'],
                              ),
                            )
                            .toList()
                        : [
                            Text(
                              i18value(context, 'you_have_no_an'),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 26),
                            )
                          ].toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  defineColor(status) {
    if (status == 'critical') {
      return Colors.red;
    } else if (status == 'normal') {
      return Colors.green;
    }
  }
}

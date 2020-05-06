import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../localization/i18value.dart';

class ConcreteAnimal extends StatefulWidget {
  static String routeNmae = '/concreteAnimal';

  @override
  _ConcreteAnimalState createState() => _ConcreteAnimalState();
}

class _ConcreteAnimalState extends State<ConcreteAnimal> {
  String id;
  SharedPreferences sharedPreferences;
  var farmCond;
  var animals;

  var dailyPart;
  var animalRation;
  var illness;
  var stDev;

  @override
  void initState() {
    super.initState();

    onloadPage();
  }

  void onloadPage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await loadAnimalData();
    await loadAnimalRation();
    await loadAnimalIllness();
    await loadAnimalStDev();
  }

  loadAnimalStDev() async {
    final request = http.Request(
      'GET',
      new Uri.https('diary-rest.herokuapp.com', 'api/resources'),
    );
    print(sharedPreferences.getString('currentAnimal'));
    request.body =
        json.encode({"animal": sharedPreferences.getString('currentAnimal')});

    request.headers.clear();
    request.headers.addAll({HttpHeaders.contentTypeHeader: "application/json"});

    stDev = await request.send();
    stDev = await stDev.stream.bytesToString();

    setState(() {
      stDev = json.decode(stDev);
    });

    print(stDev);
  }

  loadAnimalIllness() async {
    final request = http.Request(
      'GET',
      new Uri.https('diary-rest.herokuapp.com', '/api/illness'),
    );

    request.body =
        json.encode({"animal": sharedPreferences.getString('currentAnimal')});

    request.headers.clear();
    request.headers.addAll({
      "x-auth-token": sharedPreferences.getString('token'),
      HttpHeaders.contentTypeHeader: "application/json"
    });

    illness = await request.send();
    illness = await illness.stream.bytesToString();

    setState(() {
      illness = json.decode(illness);
    });
  }

  loadAnimalData() async {
    var response = await http.get(
        'https://diary-rest.herokuapp.com/api/analysis/animal/${sharedPreferences.getString('currentAnimal')}');
    dailyPart = json.decode(response.body);

    setState(() {
      dailyPart = dailyPart;
    });
  }

  loadAnimalRation() async {
    var response = await http.get(
        'https://diary-rest.herokuapp.com/api/animalRations/${sharedPreferences.getString('currentAnimal')}',
        headers: {"x-auth-token": sharedPreferences.getString('token')});
    animalRation = json.decode(response.body);

    setState(() {
      animalRation = animalRation;
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;

    id = routeArgs['id'];
    String name = routeArgs['name'];
    double temperature = routeArgs['temperature'];
    String state = routeArgs['state'];
    String species = routeArgs['species'];
    String gender = routeArgs['gender'];
    int age = routeArgs['age'];
    double weight = routeArgs['weight'];
    String farmId = routeArgs['farmId'];

    return Scaffold(
      appBar: AppBar(
        title: Text('${name[0].toUpperCase() + name.substring(1)}'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 5000,
          margin: EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 15,
          ),
          child: Column(
            children: <Widget>[
              Text(
                i18value(context, 'animal_state'),
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text(
                    i18value(context, 'animal_sp'),
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '$species',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text(
                    i18value(context, 'age_years'),
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '$age',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text(
                    i18value(context, 'gender'),
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '$gender',
                    style: TextStyle(
                        fontSize: 20,
                        color: state == 'male' ? Colors.blue : Colors.pink),
                  ),
                ],
              ),
              Divider(color: Colors.black),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text(
                    i18value(context, 'weight_kg'),
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '$weight',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text(
                    i18value(context, 'temperature_s'),
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '$temperature °C',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text(
                    i18value(context, 'state_item'),
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '$state',
                    style: TextStyle(
                        fontSize: 20,
                        color:
                            state == 'regular' ? Colors.green : Colors.black),
                  ),
                ],
              ),
              Divider(color: Colors.black),
              Container(
                height: 1000,
                child: Scaffold(
                  body: dailyPart == null
                      ? Text('')
                      : Container(
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: stDev == null ||
                                            stDev['value'] == null
                                        ? [
                                            Text(
                                              i18value(context, 'resources'),
                                              style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(i18value(context, 'no_calc')),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Divider(color: Colors.black),
                                          ]
                                        : <Widget>[
                                            Text(
                                              i18value(context, 'resources'),
                                              style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '${i18value(context, 'st_dev')} ${stDev['value'].toStringAsFixed(2)}',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  '${i18value(context, 'status')} ${stDev['conditions']['status']}',
                                                  style: TextStyle(
                                                      color: defineColor(
                                                          stDev['conditions']
                                                              ['status']),
                                                      fontSize: 20),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${stDev['conditions']['recommendation']}',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ],
                                            ),
                                            Divider(color: Colors.black),
                                          ],
                                  ),
                                  Text(
                                    i18value(context, 'daily_p'),
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${i18value(context, 'apprx_val')} ${dailyPart['value']}',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '${dailyPart['text']}',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                  Divider(color: Colors.black),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    i18value(context, 'ill_history'),
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    height: 4000,
                                    child: ListView(
                                      children: illness == null ||
                                              illness.length == 0
                                          ? [Text(i18value(context, 'no_data'))]
                                              .toList()
                                          : illness
                                              .map<Widget>((item) => Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        '${i18value(context, 'sympt')} ${item['symptoms']}',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        item['diagnosis'] ==
                                                                null
                                                            ? '${i18value(context, 'diagnosis_not_set')}'
                                                            : '${i18value(context, 'diagnosis')} ${item['diagnosis']}',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                        textAlign:
                                                            TextAlign.justify,
                                                      ),
                                                      SizedBox(height: 20),
                                                      Divider(
                                                          color: Colors.black),
                                                    ],
                                                  ))
                                              .toList(),
                                    ),
                                  ),
                                  Divider(color: Colors.black),
                                ],
                              ),
                            ],
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  defineColor(status) {
    if (status == 'satisfied') {
      return Colors.orange;
    } else if (status == 'normal') {
      return Colors.green;
    } else if (status == 'bad') {
      return Colors.red;
    }
  }
}

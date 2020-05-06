import 'package:diary_mobile/view/ConcreteFarmPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/i18value.dart';

class FarmCard extends StatelessWidget {
  final String name;
  final double humidity;
  final double temperature;
  final String id;
  final Object conditions;
  SharedPreferences sharedPreferences;

  FarmCard({
    this.id,
    this.humidity,
    this.temperature,
    this.name,
    this.conditions,
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
          borderRadius: BorderRadius.circular(5)),
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
              Tooltip(
                message: i18value(context, 'temperature'),
                child: IconButton(
                    icon: Icon(
                      Icons.format_size,
                    ),
                    onPressed: () {}),
              ),
              Text(
                ': $temperature °C',
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Tooltip(
                message: i18value(context, 'humidity'),
                child: IconButton(
                    icon: Icon(
                      Icons.scatter_plot,
                    ),
                    onPressed: () {}),
              ),
              Text(
                ': $humidity %',
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  sharedPreferences = await SharedPreferences.getInstance();
                  sharedPreferences.setString('currentFarm', id);

                  Navigator.of(context).pushNamed(
                    ConctcreteFarm.routeName,
                    arguments: {
                      'id': id,
                      'name': name,
                      'humidity': humidity,
                      'temperature': temperature,
                      'conditions': conditions,
                    },
                  );
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

import 'package:flutter/material.dart';

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
      child: Text(name),
    );
  }
}

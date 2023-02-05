import 'package:flutter/material.dart';

class DrugCard extends StatelessWidget {
  String? name;
  String? activeIngredient;
  String? splProductDataElements;
  String? indicationsAndUsage;
  String? warnings;

  DrugCard(
      {this.name,
      this.activeIngredient,
      this.splProductDataElements,
      this.indicationsAndUsage,
      this.warnings});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "$name",
                  style: TextStyle(fontSize: 30.0, color: Colors.black),
                ),
              ),
              Divider(
                height: 40.0,
                color: Colors.grey[700],
              ),
              Text(
                "Usage:",
                style: TextStyle(
                    letterSpacing: 2.0, fontSize: 18.0, color: Colors.black),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "$indicationsAndUsage",
                style: TextStyle(fontSize: 12.0, color: Colors.black),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "Active Ingredient:",
                style: TextStyle(
                    letterSpacing: 2.0, fontSize: 18.0, color: Colors.black),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "$activeIngredient",
                style: TextStyle(fontSize: 12.0, color: Colors.black),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "Product Elements:",
                style: TextStyle(
                    letterSpacing: 2.0, fontSize: 18.0, color: Colors.black),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "$splProductDataElements",
                style: TextStyle(fontSize: 12.0, color: Colors.black),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "Warnings:",
                style: TextStyle(
                    letterSpacing: 2.0, fontSize: 18.0, color: Colors.black),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "$warnings",
                style: TextStyle(fontSize: 12.0, color: Colors.black),
              ),
            ],
          ),
        ));
  }
}

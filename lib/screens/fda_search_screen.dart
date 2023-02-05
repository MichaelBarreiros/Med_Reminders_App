import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import '../widgets/loading.dart';

class FdaSearchScreen extends StatefulWidget {
  const FdaSearchScreen({Key? key}) : super(key: key);

  static const String routeName = '/fdaSearchScreen';

  @override
  _FdaSearchScreenState createState() => _FdaSearchScreenState();
}

class _FdaSearchScreenState extends State<FdaSearchScreen> {
  late TextEditingController searchController;

  bool loading = false;
  String? name;
  String? activeIngredient;
  String? splProductDataElements;
  String? indicationsAndUsage;
  String? warnings;
  String? error;

  void getData(String value) async {
    try {
      String lowerCaseValue = value.toLowerCase();
      String capitalValue = value.toUpperCase();
      String valueForAPI =
          '%22' + lowerCaseValue.replaceAll(' ', '%20') + '%22';
      String uri =
          'https://api.fda.gov/drug/label.json?&search=openfda.brand_name:$valueForAPI';

      Response response = await get(Uri.parse(uri));
      Map data = jsonDecode(response.body);
      data = data['results'][0];
      setState(() {
        name = capitalValue;
        try {
          activeIngredient = data['active_ingredient'][0];
        } catch (e) {
          activeIngredient = null;
        }
        splProductDataElements = data['spl_product_data_elements'][0];
        indicationsAndUsage = data['indications_and_usage'][0];
        warnings = data['warnings'][0];
        error = null;
        loading = false;
      });
    } catch (e) {
      String capitalValue = value.toUpperCase();
      setState(() {
        error = 'Unable to find $capitalValue';
        name = capitalValue;
        activeIngredient = null;
        splProductDataElements = null;
        indicationsAndUsage = null;
        warnings = null;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    String title = name != null ? name! : "";

    String usage = indicationsAndUsage != null ? indicationsAndUsage! : "";
    String ingredients = activeIngredient != null ? activeIngredient! : "";
    String productElements = splProductDataElements != null ? splProductDataElements! : "";
    String importantWarnings = warnings != null ? warnings! : "";

    Widget Warning = loading == false && indicationsAndUsage != null ? Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: Center(child: Text("WARNING: Information May Be Outdated", style: TextStyle(fontSize: 16.0, color: Colors.black),)),
    )
        : Text("");

    Widget Info = loading
        ? Loading()
        : indicationsAndUsage != null
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Color(0xFF6200EE), spreadRadius: 4),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Text(title, style: TextStyle(fontSize: 18.0, color: Colors.black),)),
                  ExpansionTile(
                    title: Text(
                      "Usage",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(usage, style: TextStyle(fontSize: 12.0, color: Colors.black),),
                      )
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      "Active Ingredients",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(ingredients, style: TextStyle(fontSize: 12.0, color: Colors.black),),
                      )
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      "Product Elements",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(productElements, style: TextStyle(fontSize: 12.0, color: Colors.black),),
                      )
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      "Warnings",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(importantWarnings, style: TextStyle(fontSize: 12.0, color: Colors.black),),
                      )
                    ],
                  ),
                ]
              )
            ),
          )
        : error != null
        ? Center(
        child: Text(
          "$error",
          style: TextStyle(color: Colors.black, fontSize: 20.0),
        ))
        : Text("");

    Widget SearchBar = loading || name != null ? Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
            child: TextField(
              controller: searchController,
              onSubmitted: (String value) {
                String text = searchController.text.toUpperCase();
                if (text != name! && text != "") {
                  setState(() {
                    loading = true;
                  });
                  getData(searchController.text);
                  searchController.text = "";
                } else {
                  searchController.text = "";
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF6200EE), width: 2.0,), borderRadius: BorderRadius.circular(40.0)),
                hintText: 'Search for a medication here',
              ),
            )
        ),
        IconButton(onPressed: () {
          String text = searchController.text.toUpperCase();
          if (text != name! && text != "") {
            setState(() {
              loading = true;
            });
            getData(searchController.text);
            searchController.text = "";
          } else {
            searchController.text = "";
          }
        }, icon: Icon(Icons.send),
          color: Color(0xFF6200EE),
          iconSize: 35.0,)
      ],
    ) : Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 225.0, 0.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: TextField(
                controller: searchController,
                onSubmitted: (String value) {
                  if (value != "") {
                    setState(() {
                      loading = true;
                    });
                    getData(value);
                    searchController.text = "";
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF6200EE), width: 2.0,), borderRadius: BorderRadius.circular(40.0)),
                  hintText: 'Search for a medication here',
                ),
              ),
          ),
          IconButton(onPressed: () {
            if (searchController.text != "") {
              setState(() {
                loading = true;
              });
              getData(searchController.text);
              searchController.text = "";
            }
          }, icon: Icon(Icons.send),
            color: Color(0xFF6200EE),
            iconSize: 35.0,)
        ],
      ),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBar,
            Warning,
            SizedBox(
              height: 20.0,
            ),
            Info
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;


Map? _quakes;
List? _features;
void main() async {
  _quakes = await getQuakes();

  _features=_quakes!['features'];
  // print(_quakes['features'][0]['properties']);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Quakes',
    home: new Quakes(),
  ));
}

class Quakes extends StatelessWidget {
  const Quakes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Quakes'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: new ListView.builder(
            itemCount: _features?.length,
            padding: EdgeInsets.all(15.0),
            itemBuilder: (BuildContext context, int position) {
              return new ListTile(
                title: new Text(
                    "${_features![position]['properties']['place']}"),
              );
            }),
      ),
    );
  }
}

Future<Map> getQuakes() async {
  String apiUrl =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson";
  http.Response response = await http.get(Uri.parse(apiUrl));

  return jsonDecode(response.body);
}

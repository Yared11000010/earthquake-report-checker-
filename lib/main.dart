import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

Map? _quakes;
List? _features;

void main() async {
  _quakes = await getQuakes();

  _features = _quakes!['features'];
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
              if (position.isOdd) return Divider();
              final index = position ~/ 2; //
              // we are dividing positon by 2 and returing an integer result
              var format=new DateFormat.yMMMMd("en_US").add_jm();
              var date=format.format(new DateTime.fromMicrosecondsSinceEpoch(_features![index]['properties']['time']*1000,
              isUtc: true));

              return new ListTile(
                title: new Text(
                  "At: $date",
                  style: TextStyle(
                      fontSize: 16.5,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: new Text(
                  "${_features![index]['properties']['place']}",
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                leading: new CircleAvatar(
                  backgroundColor: Colors.pink,
                  child: new Text("${_features![index]['properties']['mag']}",
                  style: new TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),),
                ),
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

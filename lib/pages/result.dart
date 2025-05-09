import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Result extends StatefulWidget {
  final String place;

  const Result({super.key, required this.place});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, dynamic>> getDataFromAPI() async {
    final response = await http.get(
      Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=${widget.place}&appid=e7917272b232ce102b4a2f03bdbd98d4&units=metric",
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return data;
    } else {
      throw Exception("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Hasil Tracking",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 70, right: 70),
          child: FutureBuilder(
            future: getDataFromAPI(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasData) {
                final data = snapshot.data!;
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // NAMA KOTA
                      Text("${data["name"]}"),
                      //SUHU
                      Text("${data["main"]["temp"]}°C"),
                      //Menampilkan Cuaca
                      Text("${data["weather"][0]["main"]}"),
                      //feels like
                      Text("suhu: ${data["main"]["feels_like"]}°C")
                    ],
                  ),
                );
              } else {
                return const Text("Tempat tidak diketahui");
              }
            },
          ),
        ),
      ),
    );
  }
}

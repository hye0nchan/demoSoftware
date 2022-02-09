import 'package:flutter/material.dart';
import 'package:fcm_notifications/config/palette.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var responseStatus = "";
var responseBody = "";

void restApiGet() async {


  var url = Uri.parse('https://example.com/whatsit/create');
  var response = await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
  responseStatus = 'Response status: ${response.statusCode}';
  responseBody = 'Response body: ${response.body}';

  print(await http.read(Uri.parse('https://example.com/foobar.txt')));
}

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {

  @override
  void initState() {
    super.initState();
    restApiGet();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            SizedBox(
              //height: screenHeight * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "FarmCare Dashboard",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu),
                      iconSize: 28.0,
                      color: Colors.white,
                      onPressed: () {
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_outlined),
                      iconSize: 28.0,
                      color: Colors.white,
                      onPressed: () {

                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        elevation: 0.0,
        backgroundColor: Palette.primaryColor,
      ),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          Container(
            child: Text('Response status: $responseStatus\nResponse body: $responseBody'),
          )

          //_buildInputIp(screenHeight)
        ],
      ),
    );
  }
}
import 'dart:convert';

import 'package:fcm_notifications/restAPI/JsonObject.dart';
import 'package:flutter/material.dart';
import 'package:fcm_notifications/config/palette.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  @override
  void initState() {
    super.initState();
    postData();
    //RestApi_Get();
    //RestApi_Post();
  }

  // void RestApi_Post() async {
  //   Map<String, dynamic> queryJson = {"login": "jjeaby", "password": "pw"};
  //   http.Response response = await http.post(
  //       Uri.parse('https://reqbin.com/echo/post/json'),
  //       headers: {"Accept": "application/json"},
  //       body: queryJson);
  //   Map<String, dynamic> responseBody = jsonDecode(response.body);
  //   print(response.body);  // 결과 출력 ==> {"success" : "true" }
  //   print(responseBody["success"]);  // 결과 출력 ==> success
  //   JsonObject jsonObject = JsonObject.fromJson(responseBody);
  //   print(jsonObject.success); // 결과 출력 ==> success
  // }

  void getData() async {
    http.Response response = await http.get(
        Uri.parse('https://10.0.2.2:44341/api/TodoItems/1'),
        headers: {"Content-Type": "application/json"});
    Map<String, dynamic> responseBodyMap = jsonDecode(response.body);
    print(response.body); // 결과 출력 ==> {"restapi" : "get" }
    print(responseBodyMap["gwId"]); // 결과 출력 ==> get
  }

  void postData() async {
    var queryJson = jsonEncode(
        {"deviceId": "0x0001", "gwId": "0x000000", "dataUnit": "sensor2"});
    http.Response response = await http.post(
        Uri.parse('https://172.20.2.87:44341/api/TodoItems'),
        headers: {"Content-Type": "application/json"},
        body: queryJson);
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    print(response.body); // 결과 출력 ==> {"success" : "true" }
    print(responseBody["gwId"]); // 결과 출력 ==> success
    JsonObject jsonObject = JsonObject.fromJson(responseBody);
    print(jsonObject.gwId); // 결과 출력 ==> success
  }

  void pumpDialog(){
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('펌프 제어'),
          content: SingleChildScrollView(
            child: Container(
              child:
              Text('This is a demo alert dialog.'),

            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_outlined),
                        iconSize: 28.0,
                        color: Colors.white,
                        onPressed: () {},
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
            _buildHeader(screenHeight, screenWidth),
            mainBody(screenHeight, screenWidth),
          ],
        ));
  }

  SliverToBoxAdapter _buildHeader(double screenHeight, double screenWidth) {
    return SliverToBoxAdapter(
      child: Container(
        height: screenHeight * 0.05,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Palette.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(45.0),
              bottomRight: Radius.circular(45.0),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "데모실 제어",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter mainBody(double screenHeight, double screenWidth) {
    return SliverToBoxAdapter(
        child: Column(children: [
      SizedBox(
        height: screenHeight * 0.03,
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(("재배기 내부 제어"),
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 25.0)),
      ),
      SizedBox(
        height: screenHeight * 0.03,
      ),
      StaggeredGrid.count(
        crossAxisCount: 4,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        children: <Widget>[
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: _buildTile2(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Material(
                            elevation: 14.0,
                            shadowColor: Color(0x802196F3),
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(24),
                            child: Center(
                                child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.power_settings_new_outlined,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ))),
                          )
                        ],
                      ),
                    ]),
              ),
            ),
          ),
          staggeredGridTile("펌프\n제어"),
          staggeredGridTile("전등\n제어"),
          staggeredGridTile("팬\n제어"),
        ],
      ),
      SizedBox(
        height: screenHeight * 0.03,
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(("재배기 외부 제어"),
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 25.0)),
      ),
      SizedBox(
        height: screenHeight * 0.03,
      ),
      StaggeredGrid.count(
          crossAxisCount: 4,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          children: <Widget>[
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: _buildTile2(
                Material(
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(12.0),
                  shadowColor: Color(0x802196F3),
                  child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Text("모터\n제어",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20)),
                      )),
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: _buildTile2(
                Material(
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(12.0),
                  shadowColor: Color(0x802196F3),
                  child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Text("팬\n제어",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20)),
                      )),
                ),
              ),
            ),
          ])
    ]));
  }


  StaggeredGridTile staggeredGridTile(String text) {
    return StaggeredGridTile.count(
      crossAxisCellCount: 1,
      mainAxisCellCount: 1,
      child: _buildTile2(
        InkWell(
          onTap: () {
            switch (text) {
              case "펌프\n제어":
                pumpDialog();
                break;
              case "전등\n제어":
                print("lamp");
                break;
              case "팬\n제어":
                print("fan");
                break;
            }
          },
          child: Material(
            elevation: 14.0,
            borderRadius: BorderRadius.circular(12.0),
            shadowColor: Color(0x802196F3),
            child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Text(text,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }

  Widget _buildTile2(Widget child) {
    return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Color(0x802196F3),
      child: InkWell(
        child: child,
      ),
    );
  }
}

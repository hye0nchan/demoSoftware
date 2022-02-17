import 'dart:convert';

import 'package:fcm_notifications/restAPI/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:fcm_notifications/config/palette.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

import '../restAPI/todo.dart';
import '../restAPI/todo_repository.dart';

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<http.Response> getData() {
    var response =  http.get(
        Uri.parse('https://172.20.2.87:44341/api/TodoItems/1'));
    print(response.toString());
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
                      style: TextStyle(
                          fontSize: 27, fontWeight: FontWeight.w700),
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
              mainBody(screenHeight, screenWidth),
            ],
          ));
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
              child: Text(("재배기 내부 센서"),
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
                StaggeredGridTile.count(
                  crossAxisCellCount: 3,
                  mainAxisCellCount: 1,
                  child: _buildTile2(
                    Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Material(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Center(
                                      child: TextButton(
                                          onPressed: () {
                                            print("펌프 테스트");
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Text(
                                              "펌프 제어",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                          ))),
                                ),
                                Material(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Center(
                                      child: TextButton(
                                          onPressed: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Text(
                                              "전등 제어",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                          ))),
                                ),
                                Material(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Center(
                                      child: TextButton(
                                          onPressed: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Text(
                                              "환풍기 제어",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                          ))),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 1,
                  child: Material(
                    elevation: 14.0,
                    borderRadius: BorderRadius.circular(12.0),
                    shadowColor: Color(0x802196F3),
                    child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('평균 값',
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(bottom: 4.0)),
                          ],
                        )),
                  ),
                )
              ],
            ),
          ]));
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
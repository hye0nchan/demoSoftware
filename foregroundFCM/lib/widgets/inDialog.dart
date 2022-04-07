import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:fcm_notifications/grpc/switch.dart';
import 'package:flutter/material.dart';

import '../config/palette.dart';
import '../config/styles.dart';
import '../data/data.dart';
import '../grpc/grpc.dart';
import '../grpc/motor.dart';

class InDialog extends StatefulWidget {
  @override
  State<InDialog> createState() => _InDialogState();
}

class _InDialogState extends State<InDialog> {

  var switchControl = SwitchControl();
  var motorControl = MotorControl();
  var grpc = Grpc();

  StatefulBuilder dialogPowerWidget(
      double screenHeight, double screenWidth, String device) {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: screenHeight * 0.03,
          ),
          if (device == "펌프" || device == "외부 팬")
            Container(
              width: screenWidth * 0.6,
              height: screenHeight * 0.1,
              child: Material(
                elevation: 14.0,
                borderRadius: BorderRadius.circular(24.0),
                shadowColor: Palette.shadowColor,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    pumpBool = !pumpBool;
                                    pumpBool
                                        ? switchControl.switchFirstOff(device)
                                        : switchControl.switchFirstOn(device);
                                  },
                                  child: Text('${device}1',
                                      style: Styles.StaggeredGridStyle)),
                              SizedBox(
                                width: screenWidth * 0.05,
                              ),
                              SizedBox(
                                width: screenWidth * 0.05,
                              ),
                              InkWell(
                                  onTap: () {
                                    // pump2Bool = !pump2Bool;
                                    // pump2Bool
                                    //     ? switchControl.switchSecondOff(device)
                                    //     : switchControl.switchSecondOn(device);
                                  },
                                  child: Text('${device}2', style: Styles.StaggeredGridStyle)),
                            ],
                          )
                        ],
                      ),
                    ]),
              ),
            ),
          SizedBox(
            height: screenHeight*0.03,
          ),
          if (device == "모터")
            Container(
              width: screenWidth * 0.6,
              height: screenHeight * 0.1,
              child: Material(
                elevation: 14.0,
                borderRadius: BorderRadius.circular(24.0),
                shadowColor: Palette.shadowColor,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      motorControl.motorLeft();
                                      grpc.sensingV();
                                      //grpc 명령어
                                    });
                                  },
                                  child: Text(
                                    "좌회전",
                                    style: Styles.dialogTileStyle,
                                  )),
                              SizedBox(
                                width: screenWidth * 0.03,
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      motorControl.motorRight();
                                      grpc.sensingV();
                                      //grpc 명령어
                                    });
                                  },
                                  child: Text("우회전",
                                      style: Styles.dialogTileStyle)),
                            ],
                          )
                        ],
                      ),
                    ]),
              ),
            ),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          if (device == "모터")
            Container(
              width: screenWidth * 0.6,
              height: screenHeight * 0.1,
              child: InkWell(
                onTap: () {
                  setState(() {
                    grpc.sensingV();
                    //grpc 명령어
                  });
                },
                child: Material(
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Palette.shadowColor,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "전압",
                                      style: Styles.StaggeredGridStyle,
                                    ),
                                    if (sensor1redVData != null)
                                      Text(
                                        "$sensor1redVData",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.blueAccent),
                                      ),
                                  ],
                                ),
                                SizedBox(
                                  width: screenWidth * 0.1,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "전류",
                                      style: Styles.StaggeredGridStyle,
                                    ),
                                    if (sensor1redVData != null)
                                      Text(
                                        "$sensor1redAData",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.blueAccent),
                                      ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          //미완성
          if (device == "test")
            Container(
              width: screenWidth * 0.6,
              height: screenHeight * 0.15,
              child: InkWell(
                onTap: () {

                },
                child: Material(
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Palette.shadowColor,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('시작 시간', style: Styles.dialogTileStyle),
                                SizedBox(
                                  width: screenWidth * 0.05,
                                ),
                                DropdownButton(
                                    isDense: true,
                                    value: pumpInitialize,
                                    onChanged: (String value) {
                                      setState(() {
                                        pumpInitialize = value;
                                        //grpc 명령어
                                      });
                                    },
                                    items: controlPeriod.map((String title) {
                                      return DropdownMenuItem(
                                        value: title,
                                        child: Text(title,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 22.0)),
                                      );
                                    }).toList()),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            Row(
                              children: [
                                Text('종료 시간', style: Styles.dialogTileStyle),
                                SizedBox(
                                  width: screenWidth * 0.05,
                                ),
                                DropdownButton(
                                    isDense: true,
                                    value: pumpInitialize,
                                    onChanged: (String value) {
                                      setState(() {
                                        pumpInitialize = value;
                                        //grpc 명령어
                                      });
                                    },
                                    items: controlPeriod.map((String title) {
                                      return DropdownMenuItem(
                                        value: title,
                                        child: Text(title,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 22.0)),
                                      );
                                    }).toList())
                              ],
                            )
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          SizedBox(
            height: screenHeight * 0.03,
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '재배기 내부 제어',
            style: Styles.headLineStyle,
          ),
        ],
      ),
      content: SizedBox(
        height: screenHeight * 0.6,
        width: screenWidth * 0.7,
        child: SingleChildScrollView(
          child: DefaultTabController(
            initialIndex: inDialogInitialize,
            length: 3,
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight*0.03,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.06,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: TabBar(
                    indicator: BubbleTabIndicator(
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                      indicatorHeight: 40.0,
                      indicatorColor: Colors.white,
                    ),
                    labelStyle: Styles.tabTextStyle,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.white,
                    tabs: <Widget>[
                      Text("펌프", style: TextStyle(fontSize: 16)),
                      Text("전등", style: TextStyle(fontSize: 16)),
                      Text("팬", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                Container(
                  height: screenHeight * 0.7,
                  child: TabBarView(children: [
                    dialogPowerWidget(screenHeight, screenWidth, "펌프"),
                    dialogPowerWidget(screenHeight, screenWidth, "전등"),
                    dialogPowerWidget(screenHeight, screenWidth, "팬"),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("닫기"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}


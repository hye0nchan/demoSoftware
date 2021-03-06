import 'dart:async';

import 'package:fcm_notifications/grpc/motor.dart';
import 'package:fcm_notifications/grpc/switch.dart';
import 'package:fcm_notifications/widgets/inDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fcm_notifications/config/palette.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../config/styles.dart';
import '../data/data.dart';
import '../grpc/grpc.dart';
import '../widgets/outDialog.dart';

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  @override
  void initState() {
    super.initState();
  }

  //class
  var grpc = Grpc();
  var motorControl = MotorControl();
  var switchControl = SwitchControl();

  Timer sensingTimer;
  Timer eTimer;

  @override
  void dispose() {
    sensingTimer?.cancel();
    eTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          actions: [],
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "FarmCare Dashboard",
                    textAlign: TextAlign.center,
                    style: Styles.appbarStyle,
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
              "????????? ??????",
              style: Styles.buildHeadStyle,
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
      headMaterial("????????? ?????? ??????"),
      SizedBox(
        height: screenHeight * 0.01,
      ),
      StaggeredGrid.count(
        crossAxisCount: 4,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        children: <Widget>[
          //powerTile(),
          StaggeredGridTile.count(
            crossAxisCellCount: 4,
            mainAxisCellCount: 1,
            child: Material(
              elevation: 14.0,
              borderRadius: BorderRadius.circular(30.0),
              shadowColor: Palette.shadowColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    onMaterial("??????1", pumpBool),
                    onMaterial("??????2", pumpBool2),
                    onMaterial("??????", lampBool),
                    onMaterial("???", fanBool),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      SizedBox(
        height: screenHeight * 0.015,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          settingMaterialLeft(screenHeight, screenWidth, "??????"),
          settingMaterialRight(screenHeight, screenWidth, "??????"),
        ],
      ),
      SizedBox(
        height: screenHeight * 0.03,
      ),
      headMaterial("????????? ?????? ??????"),
      SizedBox(
        height: screenHeight * 0.01,
      ),
      StaggeredGrid.count(
        crossAxisCount: 4,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        children: <Widget>[
          //powerTile(),
          StaggeredGridTile.count(
            crossAxisCellCount: 4,
            mainAxisCellCount: 1,
            child: Material(
              elevation: 14.0,
              borderRadius: BorderRadius.circular(30.0),
              shadowColor: Palette.shadowColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    onMaterial("??????(???)", motorBool),
                    onMaterial("??????(???)", motorBool2),
                    onMaterial("?????????1", outFanBool),
                    onMaterial("?????????2", outFanBool2),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      SizedBox(
        height: screenHeight * 0.015,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          settingMaterialLeft(screenHeight, screenWidth, "??????"),
          settingMaterialRight(screenHeight, screenWidth, "??????"),
        ],
      ),
      SizedBox(
        height: screenHeight * 0.03,
      ),
      Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(50),
        shadowColor: Palette.shadowColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (temSparkLine.isNotEmpty)
                      Text("?????? ??????", style: Styles.headLineStyle)
                  ],
                ),
              ]),
        ),
      ),
      SizedBox(
        height: screenHeight * 0.015,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: screenWidth * 0.33,
              height: screenHeight * 0.08,
              child: Material(
                elevation: 14.0,
                borderRadius: BorderRadius.circular(50),
                shadowColor: Palette.shadowColor,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                      child: Switch(
                        value: eValue,
                        onChanged: (value){
                          setState(() {
                            eValue = value;
                            if(eValue){
                              eTimer =
                                  Timer.periodic(Duration(milliseconds: 4000), (timer) {
                                    setState(() {
                                      grpc.sensingV();
                                    });
                                  });
                            }
                            else{
                              eTimer.cancel();
                            }
                          });
                        },
                      ),
                  ),
                ),
              ),
          ),
          SizedBox(
            width: screenWidth * 0.02,
          ),
          Container(
            width: screenWidth * 0.62,
            height: screenHeight * 0.08,
            child: Material(
              elevation: 14.0,
              borderRadius: BorderRadius.circular(50),
              shadowColor: Palette.shadowColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                        child: Text('?????? : $sensor1redAData',
                            style: Styles.StaggeredGridStyle)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                        child: Text('?????? : $sensor1redVData',
                            style: Styles.StaggeredGridStyle)),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      SizedBox(
        height: screenHeight * 0.03,
      ),
    ]));
  }

  Material headMaterial(String text) {
    return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(50),
      shadowColor: Palette.shadowColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (temSparkLine.isNotEmpty)
                    Text(text, style: Styles.headLineStyle)
                ],
              ),
            ]),
      ),
    );
  }

  Column onMaterial(String text, bool onOff) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('$text',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 18)),
        Switch(
            activeColor: Colors.blueAccent,
            value: onOff,
            onChanged: (value) {
              switch (text) {
                case "??????1":
                  setState(() {
                    pumpBool
                        ? switchControl.switchFirstOff("??????")
                        : switchControl.switchFirstOn("??????");
                    pumpBool = !pumpBool;
                  });
                  break;
                case "??????2":
                  setState(() {
                    pumpBool2
                        ? switchControl.switchSecondOff("??????")
                        : switchControl.switchSecondOn("??????");
                    pumpBool2 = !pumpBool2;
                  });
                  break;
                case "??????":
                  setState(() {
                    lampBool
                        ? switchControl.switchFirstOff("??????")
                        : switchControl.switchFirstOn("??????");
                    lampBool = !lampBool;
                  });
                  break;
                case "???":
                  setState(() {
                    fanBool
                        ? switchControl.switchSecondOff("??????")
                        : switchControl.switchSecondOn("??????");
                    fanBool = !fanBool;
                  });
                  break;
                case "??????(???)":
                  motorBool = !motorBool;
                  if (motorBool) {
                    setState(() {
                      motorBool2 = false;
                      motorControl.motorLeft();
                      sensingTimer =
                          Timer.periodic(Duration(milliseconds: 3000), (timer) {
                        setState(() {
                          grpc.sensingV();
                        });
                      });
                    });
                  } else {
                    setState(() {

                      motorControl.motorStop();
                      sensingTimer.cancel();
                    });
                  }
                  break;
                case "??????(???)":
                  motorBool2 = !motorBool2;
                  if (motorBool2) {
                    setState(() {
                      motorBool = false;
                      motorControl.motorRight();
                      sensingTimer =
                          Timer.periodic(Duration(milliseconds: 4000), (timer) {
                            setState(() {
                              grpc.sensingV();
                            });
                          });
                    });
                  } else {

                    setState(() {
                      motorControl.motorStop();
                      sensingTimer.cancel();
                    });
                  }
                  break;
                case "?????????1":
                  setState(() {
                    outFanBool
                        ? switchControl.switchFirstOff("?????????")
                        : switchControl.switchFirstOn("?????????");
                    outFanBool = !outFanBool;
                  });
                  break;
                case "?????????2":
                  setState(() {
                    outFanBool2
                        ? switchControl.switchSecondOff("?????????")
                        : switchControl.switchSecondOn("?????????");
                    outFanBool2 = !outFanBool2;
                  });
                  break;
              }
            }),
      ],
    );
  }

  Container settingMaterialLeft(
      double screenHeight, double screenWidth, String inOut) {
    return Container(
      width: screenWidth * 0.47,
      height: screenHeight * 0.1,
      child: Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(50),
        shadowColor: Palette.shadowColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
              child: Text('$inOut ?????? ??????', style: Styles.StaggeredGridStyle)),
        ),
      ),
    );
  }

  Container settingMaterialRight(
      double screenHeight, double screenWidth, String inOut) {
    List<String> deviceLists = [];
    (inOut == "??????")
        ? deviceLists = ["??????", "??????", "???"]
        : deviceLists = ["??????", "?????????"];
    return Container(
      width: screenWidth * 0.5,
      height: screenHeight * 0.1,
      child: Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(50),
        shadowColor: Palette.shadowColor,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Text(
                  "${deviceLists[0]}",
                  style: Styles.tabSettingTextStyle,
                ),
                onPressed: () {
                  inDialogInitialize = 0;

                  (inOut == "??????")
                      ? showDialog(
                          context: context,
                          builder: (_) {
                            return InDialog();
                          })
                      : showDialog(
                          context: context,
                          builder: (_) {
                            return OutDialog();
                          });
                },
              ),
              TextButton(
                child: Text(
                  "${deviceLists[1]}",
                  style: Styles.tabSettingTextStyle,
                ),
                onPressed: () {
                  inDialogInitialize = 1;

                  (inOut == "??????")
                      ? showDialog(
                          context: context,
                          builder: (_) {
                            return InDialog();
                          })
                      : showDialog(
                          context: context,
                          builder: (_) {
                            return OutDialog();
                          });
                },
              ),
              if (inOut == "??????")
                TextButton(
                  child: Text(
                    "${deviceLists[2]}",
                    style: Styles.tabSettingTextStyle,
                  ),
                  onPressed: () {
                    inDialogInitialize = 2;

                    (inOut == "??????")
                        ? showDialog(
                            context: context,
                            builder: (_) {
                              return InDialog();
                            })
                        : showDialog(
                            context: context,
                            builder: (_) {
                              return OutDialog();
                            });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

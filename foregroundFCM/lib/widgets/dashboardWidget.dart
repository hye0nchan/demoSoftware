import 'dart:core';

import 'package:fcm_notifications/config/palette.dart';
import 'package:fcm_notifications/config/styles.dart';
import 'package:fcm_notifications/data/data.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:sparkline/sparkline.dart';

import '../grpc/grpc.dart';
import '../main.dart';

class DashboardWidget extends StatefulWidget {
  @override
  State<DashboardWidget> createState() => new DashboardWidgetState();

  static DashboardWidgetState of(BuildContext context) =>
      context.findAncestorStateOfType<DashboardWidgetState>();
}

class DashboardWidgetState extends State<DashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

var home = MyApp();
var grpc = Grpc();

Widget _buildTile(Widget child, {Function() onTap}) {
  return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Palette.shadowColor,
      child:
          InkWell(onTap: onTap != null ? () => onTap() : () {}, child: child));
}

StatefulBuilder menuWidget(double screenHeight, double screenWidth) {
  return StatefulBuilder(builder: (context, setState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: screenHeight * 0.03,
        ),
        Container(
          width: screenWidth * 0.6,
          height: screenHeight * 0.2,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('?????? ??????', style: Styles.dialogTileStyle),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Container(
                            width: screenWidth * 0.4,
                            child: TextField(
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.blueAccent),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.blueAccent),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  hintText: '?????? ??????',
                                  labelStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300)),
                            ),
                          )
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () {
                                grpc.receiveMessage();
                              },
                              child: Text('gRPC ?????? ??????',
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () {
                                grpc.sensingV();
                              },
                              child: Text('????????? ?????? ?????????',
                                  style: Styles.dialogTileStyle)),
                        ],
                      )
                    ],
                  ),
                ]),
          ),
        ),
      ],
    );
  });
}

StatefulBuilder deviceEditWidget(double screenHeight, double screenWidth) {
  return StatefulBuilder(builder: (context, setState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: screenHeight * 0.03,
        ),
        Container(
          width: screenWidth * 0.6,
          height: screenHeight * 0.2,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('?????? ??????', style: Styles.dialogTileStyle),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Container(
                            width: screenWidth * 0.4,
                            child: TextField(
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.blueAccent),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.blueAccent),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  hintText: '?????? ??????',
                                  labelStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300)),
                            ),
                          )
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
        Container(
          width: screenWidth * 0.6,
          height: screenHeight * 0.2,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('?????? ??????', style: Styles.dialogTileStyle),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Container(
                            width: screenWidth * 0.4,
                            child: DropdownButton(
                                isDense: true,
                                value: deviceList[0],
                                onChanged: (String value) {
                                  setState(() {
                                    motorDevice = Int64.parseInt(int.parse("0x"+value).toString());
                                  });
                                },
                                items: deviceList.map((String title) {
                                  return DropdownMenuItem(
                                    value: title,
                                    child: Text(title,
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 22.0)),
                                  );
                                }).toList()),
                          )
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
      ],
    );
  });
}

Widget inHomeDataTile(String sensor) {
  List<double> sparkLine = [];
  String data = "0";

  switch (sensor) {
    case "??????":
      sparkLine = tem2SparkLine;
      data = '${double.parse(tem2SparkLine.last.toStringAsFixed(2))}??C';
      break;

    case "??????":
      sparkLine = hum2SparkLine;
      data = '${double.parse(hum2SparkLine.last.toStringAsFixed(2))}%';
      break;

    case "??????":
      sparkLine = lux2SparkLine;
      data = '${double.parse(lux2SparkLine.last.toStringAsFixed(2))}lm';
      break;

    case "???????????????":
      sparkLine = co22SparkLine;
      data = '${double.parse(co22SparkLine.last.toStringAsFixed(2))}ppm';
      break;
  }
  return _buildTile(
    Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (sparkLine.isNotEmpty)
                  Text('$sensor', style: Styles.graphAverageStyle),
                if (sparkLine.isNotEmpty)
                  Text(data, style: Styles.homeDataStyle)
              ],
            ),
          ]),
    ),
  );
}

Widget outHomeDataTile(String sensor) {
  List<double> sparkLine = [];
  String data = "0";

  switch (sensor) {
    case "??????":
      sparkLine = temSparkLine;
      data = '${double.parse(temSparkLine.last.toStringAsFixed(2))}??C';
      break;

    case "??????":
      sparkLine = humSparkLine;
      data = '${double.parse(humSparkLine.last.toStringAsFixed(2))}%';
      break;

    case "??????":
      sparkLine = luxSparkLine;
      data = '${double.parse(luxSparkLine.last.toStringAsFixed(2))}lm';
      break;

    case "???????????????":
      sparkLine = co2SparkLine;
      data = '${double.parse(co2SparkLine.last.toStringAsFixed(0))}ppm';
      break;
  }
  return _buildTile(
    Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (sparkLine.isNotEmpty)
                  Text('$sensor',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.green)),
                if (sparkLine.isNotEmpty)
                  Text(data, style:
                  Styles.homeDataStyle)
              ],
            ),
          ]),
    ),
  );
}

Visibility inGraphSpark(List<double> list, int index) {
  return Visibility(
    visible: averageInMap[index],
    child: Sparkline(
      data: list,
      lineWidth: 5.0,
      lineColor: Colors.blueAccent,
    ),
  );
}

Visibility inGraphText(String text, int index) {
  return Visibility(
    visible: averageInMap[index],
    child: Text('$text', style: Styles.homeDataStyle),
  );
}

Visibility outGraphSpark(List<double> list, int index) {
  return Visibility(
    visible: averageOutMap[index],
    child: Sparkline(
      data: list,
      lineWidth: 5.0,
      lineColor: Colors.green,
    ),
  );
}

Visibility outGraphText(String text, int index) {
  return Visibility(
    visible: averageOutMap[index],
    child: Text('$text', style: Styles.homeDataStyle),
  );
}

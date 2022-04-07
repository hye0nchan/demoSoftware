import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:fcm_notifications/grpc/motor.dart';
import 'package:fcm_notifications/grpc/switch.dart';
import 'package:flutter/material.dart';
import 'package:fcm_notifications/config/palette.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../config/styles.dart';
import '../data/data.dart';
import '../grpc/grpc.dart';

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

  int inDialogInitialize = 0;
  int outDialogInitialize = 0;

  void inDialog() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
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
                  length: 4,
                  child: Column(
                    children: [
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
                            Text("센서", style: TextStyle(fontSize: 16)),
                            Text("펌프", style: TextStyle(fontSize: 16)),
                            Text("전등", style: TextStyle(fontSize: 16)),
                            Text("팬", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      Container(
                        height: screenHeight * 0.7,
                        child: TabBarView(children: [
                          dialogPowerWidget(screenHeight, screenWidth, "센서"),
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
        });
      },
    );
  }

  void outDialog() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '재배기 외부 제어',
                  style: Styles.headLineStyle,
                ),
              ],
            ),
            content: SizedBox(
              height: screenHeight * 0.6,
              width: screenWidth * 0.7,
              child: SingleChildScrollView(
                child: DefaultTabController(
                  initialIndex: outDialogInitialize,
                  length: 2,
                  child: Column(
                    children: [
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
                            Text("모터", style: TextStyle(fontSize: 18)),
                            Text("외부 팬", style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                      Container(
                        height: screenHeight * 0.7,
                        child: TabBarView(children: [
                          dialogPowerWidget(screenHeight, screenWidth, "모터"),
                          dialogPowerWidget(screenHeight, screenWidth, "외부 팬"),
                        ]),
                      )
                    ],
                  ),
                ),
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
        });
      },
    );
  }

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
          if (device != "펌프" && device !="외부 팬")
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
                              Text('$device 전원', style: Styles.headLineStyle),
                              SizedBox(
                                width: screenWidth * 0.05,
                              ),
                              powerMaterial(device)
                            ],
                          )
                        ],
                      ),
                    ]),
              ),
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
                                    pump2Bool = !pump2Bool;
                                    pump2Bool
                                        ? switchControl.switchSecondOff(device)
                                        : switchControl.switchSecondOn(device);
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

  StatefulBuilder dialogTab(
      double screenWidth, double screenHeight, String device) {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: screenHeight * 0.03,
          ),
          Container(
            height: screenHeight * 0.3,
            width: screenWidth * 0.7,
            child: StaggeredGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: 50.0,
                mainAxisSpacing: 30.0,
                children: <Widget>[
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 2,
                    child: Material(
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(12.0),
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
                                    Text('$device 전원',
                                        style: Styles.headLineStyle),
                                    SizedBox(
                                      width: screenWidth * 0.05,
                                    ),
                                    powerMaterial("sensor")
                                  ],
                                )
                              ],
                            ),
                          ]),
                    ),
                  ),
                ]),
          ),
        ],
      );
    });
  }

  //

  Material powerMaterial(String device) {
    return Material(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.circular(24),
      child: Center(
          child: IconButton(
        onPressed: () {
          switch (device) {
            case "센서":
              setState(() {
                sensorBool = !sensorBool;
                //grpc 명령어
              });
              break;
            case "펌프":
              setState(() {
                if (pumpBool) {
                  switchControl.switchSecondOff("펌프");
                  switchControl.switchFirstOff("펌프");
                } else {
                  switchControl.switchFirstOn("펌프");
                  switchControl.switchSecondOn("펌프");
                }

                pumpBool = !pumpBool;
              });
              break;

            case "전등":
              setState(() {
                if (lampBool) {
                  switchControl.switchFirstOff("램프");
                } else {
                  switchControl.switchFirstOn("램프");
                }

                lampBool = !lampBool;
              });
              break;

            case "팬":
              setState(() {
                if (fanBool) {
                  switchControl.switchSecondOff("팬");
                } else {
                  switchControl.switchSecondOn("팬");
                }

                fanBool = !fanBool;
              });
              break;

            case "모터":
              setState(() {
                motorBool = !motorBool;
                motorControl.motorStop();
                grpc.sensingV();
              });
              break;

            case "외부 팬":
              setState(() {
                outFanBool = !outFanBool;
                outFanBool
                ? switchControl.switchSecondOff("외부 팬")
                    : switchControl.switchSecondOn("외부 팬");
              });
              break;
          }
        },
        icon: Icon(
          Icons.power_settings_new_outlined,
          color: Colors.white,
          size: 30,
        ),
      )),
    );
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
              "데모실 제어",
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
      Material(
        elevation: 14.0,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
        shadowColor: Palette.shadowColor,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (temSparkLine.isNotEmpty)
                      Text('재배기 내부 제어', style: Styles.headLineStyle)
                  ],
                ),
              ]),
        ),
      ),
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
                    onMaterial("센서", sensorBool),
                    onMaterial("펌프", pumpBool),
                    onMaterial("전등", lampBool),
                    onMaterial("팬", fanBool),
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
      StaggeredGrid.count(
        crossAxisCount: 4,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        children: <Widget>[
          inStaggeredGridTile("센서\n제어"),
          inStaggeredGridTile("펌프\n제어"),
          inStaggeredGridTile("전등\n제어"),
          inStaggeredGridTile("팬\n제어"),
        ],
      ),
      SizedBox(
        height: screenHeight * 0.03,
      ),
      Material(
        elevation: 14.0,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
        shadowColor: Palette.shadowColor,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (temSparkLine.isNotEmpty)
                      Text('재배기 외부 제어', style: Styles.headLineStyle)
                  ],
                ),
              ]),
        ),
      ),
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
                    onMaterial("모터", motorBool),
                    onMaterial("팬", outFanBool),
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
      StaggeredGrid.count(
          crossAxisCount: 4,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          children: <Widget>[
            outStaggeredGridTile("모터\n제어"),
            outStaggeredGridTile("외부 팬\n제어"),
          ])
    ]));
  }

  Column onMaterial(String text, bool onOff) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('$text 전원',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 17)),
        if (onOff)
          Text('ON',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w700,
                  fontSize: 34.0)),
        if (!onOff)
          Text('OFF',
              style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w700,
                  fontSize: 34.0)),
      ],
    );
  }

  StaggeredGridTile outStaggeredGridTile(String text) {
    return StaggeredGridTile.count(
      crossAxisCellCount: 2,
      mainAxisCellCount: 1,
      child: _buildTile(
        InkWell(
          onTap: () {
            switch (text) {
              case "모터\n제어":
                outDialogInitialize = 0;
                outDialog();
                break;
              case "외부 팬\n제어":
                outDialogInitialize = 1;
                outDialog();
                break;
            }
          },
          child: Material(
            elevation: 14.0,
            borderRadius: BorderRadius.circular(12.0),
            shadowColor: Palette.shadowColor,
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

  Padding powerTile(String device) {
    return Padding(
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
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(24),
                  child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: IconButton(
                            onPressed: () {
                              switch (device) {
                                case "sensor":
                                  setState(() {
                                    sensorBool = !sensorBool;
                                    //grpc 명령어
                                  });
                                  break;

                                case "pump":
                                  setState(() {
                                    pumpBool = !pumpBool;
                                  });
                                  break;

                                case "lamp":
                                  setState(() {
                                    lampBool = !lampBool;
                                  });
                                  break;

                                case "fan":
                                  setState(() {
                                    fanBool = !fanBool;
                                  });
                                  break;

                                case "motor":
                                  setState(() {
                                    motorBool = !motorBool;
                                  });
                                  break;

                                case "outFan":
                                  setState(() {
                                    outFanBool = !outFanBool;
                                  });
                                  break;
                              }
                            },
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
    );
  }

  StaggeredGridTile inStaggeredGridTile(String text) {
    return StaggeredGridTile.count(
      crossAxisCellCount: 1,
      mainAxisCellCount: 1,
      child: _buildTile(
        InkWell(
          onTap: () {
            switch (text) {
              case "센서\n제어":
                inDialogInitialize = 0;
                inDialog();
                break;
              case "펌프\n제어":
                inDialogInitialize = 1;
                inDialog();
                break;
              case "전등\n제어":
                inDialogInitialize = 2;
                inDialog();
                break;
              case "팬\n제어":
                inDialogInitialize = 3;
                inDialog();
                break;
            }
          },
          child: Material(
            elevation: 14.0,
            borderRadius: BorderRadius.circular(12.0),
            shadowColor: Palette.shadowColor,
            child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Text(text,
                      textAlign: TextAlign.center,
                      style: Styles.StaggeredGridStyle),
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(Widget child) {
    return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Palette.shadowColor,
      child: InkWell(
        child: child,
      ),
    );
  }
}

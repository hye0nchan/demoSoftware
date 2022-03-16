// ignore_for_file: deprecated_member_use, unnecessary_statements

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:influxdb_client/api.dart';
import 'package:fcm_notifications/config/palette.dart';
import 'package:fcm_notifications/config/styles.dart';
import 'package:fcm_notifications/data/data.dart';
import 'package:fcm_notifications/data/function.dart';
import 'package:fcm_notifications/data/grpc.dart';
import 'package:fcm_notifications/data/influxDB.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../main.dart';
import 'package:sparkline/sparkline.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final List<String> chartDropdownItems = ['온도', '습도', 'CO2', '조도'];
  String actualDropdown = "온도";
  String actualDropdown2 = "온도";
  int actualChart = 0;

  var grpc = Grpc();
  var functionBox = FunctionBox();
  var home = MyApp();
  var influxDB = AddInfluxDB();

  TextEditingController ipInputController = TextEditingController();

  bool switchValue = true;

  get nn => null;

  int temDataCount = 0;
  int humDataCount = 0;
  int co2DataCount = 0;
  int uvDataCount = 0;
  int nh3DataCount = 0;
  int nh3LDataCount = 0;
  int nh3MDataCount = 0;
  int nh3HDataCount = 0;
  int luxDataCount = 0;
  int no2DataCount = 0;
  int no2LDataCount = 0;
  int no2MDataCount = 0;
  int no2HDataCount = 0;
  int coDataCount = 0;
  int coLDataCount = 0;
  int coMDataCount = 0;
  int coHDataCount = 0;

  void getData() async {
    http.Response response = await http.get(
        Uri.parse('https://172.20.2.87/api/TodoItems/1'),
        headers: {"Accept": "application/json"});
    Map<String, dynamic> responseBodyMap = jsonDecode(response.body);
    print(response.body); // 결과 출력 ==> {"restapi" : "get" }
    print(responseBodyMap["gwId"]); // 결과 출력 ==> get
  }

  void reReadInfluxDB() async {
    for (int i = 0; i < allSensorList.length; i++) {
      var sensorStream = await queryService.query('''
  from(bucket: "farmcare")
  |> range(start: -24h)
  |> filter(fn: (r) => r["_measurement"] == "${allSensorList[i]}")
  |> yield(name: "mean")
  ''');
      await sensorStream.forEach((record) {
        var value = record['_value'];

        if (i != 4 && value != 0) {
          if (i < 3 && i > 0) {
            if (i == 0) {
              if (!temSparkLine.contains(value)) {
                setState(() {
                  temSparkLine.add(value);
                  temTotalSparkLine += value;
                  totalTemCount += 1;
                });
              }
            }
            if (i == 1) {
              if (!tem2SparkLine.contains(value)) {
                setState(() {
                  tem2SparkLine.add(value);
                  tem2TotalSparkLine += value;
                  totalTem2Count += 1;
                });
              }
            }
          }
          if (i < 6 && i > 2) {
            if (i == 3) {
              if (!humSparkLine.contains(value)) {
                setState(() {
                  humSparkLine.add(value);
                  humTotalSparkLine += value;
                  totalHumCount += 1;
                });
              }
            }
            if (i == 4) {
              if (!hum2SparkLine.contains(value)) {
                setState(() {
                  hum2SparkLine.add(value);
                  hum2TotalSparkLine += value;
                  totalHum2Count += 1;
                });
              }
            }
          }
          if (i < 9 && i > 5) {
            if (i == 6) {
              if (!co2SparkLine.contains(value)) {
                setState(() {
                  co2SparkLine.add(value);
                  co2TotalSparkLine += value;
                  totalCo2Count += 1;
                });
              }
            }
            if (i == 7) {
              if (!co22SparkLine.contains(value)) {
                setState(() {
                  co22SparkLine.add(value);
                  co22TotalSparkLine += value;
                  totalCo22Count += 1;
                });
              }
            }
          }
          if (8 < i && i < 11) {
            if (i == 9) {
              if (!luxSparkLine.contains(value)) {
                setState(() {
                  luxSparkLine.add(value);
                  luxTotalSparkLine += value;
                  totalLuxCount += 1;
                });
              }
            }
            if (i == 10) {
              if (!lux2SparkLine.contains(value)) {
                setState(() {
                  lux2SparkLine.add(value);
                  lux2TotalSparkLine += value;
                  totalLux2Count += 1;
                });
              }
            }
          }
        }
      });
    }

    setState(() {
      temTotalValue =
          double.parse((temTotalSparkLine / totalTemCount).toStringAsFixed(2));

      tem2TotalValue = double.parse(
          (tem2TotalSparkLine / totalTem2Count).toStringAsFixed(2));

      humTotalValue =
          double.parse((humTotalSparkLine / totalHumCount).toStringAsFixed(2));

      hum2TotalValue = double.parse(
          (hum2TotalSparkLine / totalHum2Count).toStringAsFixed(2));

      co2TotalValue =
          double.parse((co2TotalSparkLine / totalCo2Count).toStringAsFixed(2));

      co22TotalValue = double.parse(
          (co22TotalSparkLine / totalCo22Count).toStringAsFixed(2));

      luxTotalValue =
          double.parse((luxTotalSparkLine / totalLuxCount).toStringAsFixed(2));

      lux2TotalValue = double.parse(
          (lux2TotalSparkLine / totalLux2Count).toStringAsFixed(2));
    });
  }

  void refreshAll() {
    refreshSensor3();
    sleep(const Duration(seconds: 1));
    refreshSensor2();
    sleep(const Duration(seconds: 1));
    refreshSensor1();
  }

  Future<void> refreshSensor1() async {
    grpc.sendSensor1();

    var tem1Value = double.parse(sensor1redTemData);
    var hum1Value = double.parse(sensor1redHumData);
    var co21Value = double.parse(sensor1redCo2Data);
    var lux1Value = double.parse(sensor1redLuxData);

    if (this.mounted) {
      setState(() {
        temValue = tem1Value;
        humValue = hum1Value;
        co2Value = co21Value;
        luxValue = lux1Value;
      });
    }
  }

  Future<void> refreshSensor2() async {
    grpc.sendSensor2();

    var tem2Value = double.parse(sensor2redTemData);
    var hum2Value = double.parse(sensor2redTemData);
    var co22Value = double.parse(sensor2redTemData);
    var lux2Value = double.parse(sensor2redTemData);

    if (this.mounted) {
      setState(() {
        tem2Value = tem2Value;
        hum2Value = hum2Value;
        co22Value = co22Value;
        lux2Value = lux2Value;
      });
    }
  }

  Future<void> refreshSensor3() async {
    timerSensor3 =
        Timer.periodic(Duration(seconds: intRecyclePeriod), (timer) async {
      grpc.sendSensor3();

      (isCheckedMap[0]) ? influxDB.tem3AddInfluxDB() : null;
      (isCheckedMap[1]) ? influxDB.hum3AddInfluxDB() : null;
      (isCheckedMap[2]) ? influxDB.co23AddInfluxDB() : null;
      (isCheckedMap[3]) ? influxDB.lux3AddInfluxDB() : null;
      (isCheckedMap[4]) ? influxDB.uv3AddInfluxDB() : null;
      (isCheckedMap[5]) ? influxDB.nh33AddInfluxDB() : null;
      (isCheckedMap[6]) ? influxDB.nh3L3AddInfluxDB() : null;
      (isCheckedMap[7]) ? influxDB.nh3M3AddInfluxDB() : null;
      (isCheckedMap[8]) ? influxDB.nh3H3AddInfluxDB() : null;
      (isCheckedMap[9]) ? influxDB.no23AddInfluxDB() : null;
      (isCheckedMap[10]) ? influxDB.no2L3AddInfluxDB() : null;
      (isCheckedMap[11]) ? influxDB.no2M3AddInfluxDB() : null;
      (isCheckedMap[12]) ? influxDB.no2H3AddInfluxDB() : null;
      (isCheckedMap[13]) ? influxDB.co3AddInfluxDB() : null;
      (isCheckedMap[14]) ? influxDB.coL3AddInfluxDB() : null;
      (isCheckedMap[15]) ? influxDB.coM3AddInfluxDB() : null;
      (isCheckedMap[16]) ? influxDB.coH3AddInfluxDB() : null;
    });
  }

  // Future<void> refreshTem() async {
  //   setState(() {
  //     // nullTem = sensor1redTemData();
  //     // temValue = double.parse(sensor1redTemData);
  //   });
  //   redTemDataList.add(sensor1redTemData.toString());
  //   redTemDateList.add(hourMin);
  //   temStack += 1;
  //
  //   lastTemData = double.parse(sensor1redTemData);
  // }

  void co2AddInfluxDB() async {
    var temInfluxValue = double.parse(sensor1redTemData);
    var temperatureInflux = Point('tem1')
        .addTag('location', 'a')
        .addField('value', temInfluxValue)
        .time(DateTime.now().toUtc());

    await writeApi.write(temperatureInflux);
  }

  void luxAddInfluxDB() async {
    var temInfluxValue = double.parse(sensor1redTemData);
    var temperatureInflux = Point('tem1')
        .addTag('location', 'a')
        .addField('value', temInfluxValue)
        .time(DateTime.now().toUtc());

    await writeApi.write(temperatureInflux);
  }

  void uvAddInfluxDB() async {
    var temInfluxValue = double.parse(sensor1redTemData);
    var temperatureInflux = Point('tem1')
        .addTag('location', 'a')
        .addField('value', temInfluxValue)
        .time(DateTime.now().toUtc());

    await writeApi.write(temperatureInflux);
  }

  void delInfluxDB() async {
    await client
        .getDeleteService()
        .delete(
            predicate: '_measurement="nh3"',
            start: DateTime.utc(1989, 11, 9),
            stop: DateTime.now().toUtc(),
            bucket: 'farmcare',
            org: 'saltanb')
        .catchError((e) => print(e));
  }

  @override
  void initState() {
    super.initState();
    getToken();
    hideGauge();
    actualDropdown = beforeActually;
    actualDropdown2 = beforeActually2;
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android?.smallIcon,
              ),
            ));
      }
    });
  }

  void getToken() async {
    if (tokenCount) {
      String token = await FirebaseMessaging.instance.getToken(); //디바이스 토큰 가져오기

      print("현재 토큰 : $token");

      final f = FirebaseFirestore.instance; // 인스턴스 할당
      String firesStoreToken;

      await f //fireStore에 저장된 토큰 전부 가져오기
          .collection("Token")
          .get()
          .then((QuerySnapshot ds) async {
        if (ds.docs.length == 0) {
          //등록된 디바이스가 없으면
          await f //fireStore에 저장
              .collection('Token')
              .doc('device1')
              .set({'value': token});
          print(ds.docs.length);
        }
      });

      await f //fireStore에 저장된 토큰 전부 가져오기
          .collection("Token")
          .get()
          .then((QuerySnapshot ds) async {
        ds.docs.forEach((doc) async {
          if (ds.docs.length != 0) {
            firesStoreToken = doc["value"];
            fireStoreTokenList.add(firesStoreToken); //가져온 토큰 리스트에 저장
          }
        });
      });

      print("토큰 리스트 : $fireStoreTokenList");

      if (fireStoreTokenList.contains(token) == false) {
        print("enter if");
        await f //fireStore에 저장
            .collection('Token')
            .doc('device${fireStoreTokenList.length + 1}')
            .set({'value': token});
      }
    }
    tokenCount = false;
  }

  //Dialog

  void _showMenu() {
    functionBox.changeVisibilityMenuLists(0);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Close",
                  style: TextStyle(fontSize: 14),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Text(
                    "Menu",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                DefaultTabController(
                  length: 3,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Palette.primaryColor,
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
                          Text("Network"),
                          Text("Sensor"),
                          Text("Last Data"),
                        ],
                        onTap: (index) {
                          switch (index) {
                            case 0:
                              setState(() {
                                functionBox.changeVisibilityMenuLists(0);
                              });
                              break;
                            case 1:
                              setState(() {
                                functionBox.changeVisibilityMenuLists(1);
                              });
                              break;
                            case 2:
                              setState(() {
                                functionBox.changeVisibilityMenuLists(2);
                              });
                              break;
                          }
                        }),
                  ),
                ),
              ],
            ),
            content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Stack(
                    children: [
                      Visibility(
                        visible: visibilityMenuMap[0],
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: RaisedButton(
                                  elevation: 0.0,
                                  color: Colors.lightBlue,
                                  onPressed: grpc.getIp,
                                  child: Text(
                                    "Get Server IP",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: RaisedButton(
                                  elevation: 0.0,
                                  color: Colors.lightBlue,
                                  onPressed: grpc.receiveMessage,
                                  child: Center(
                                    child: Text(
                                      "Connect Server",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 50.0,
                                  vertical: 10.0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Palette.primaryColor,
                                    borderRadius: BorderRadius.circular(20.0)),
                                alignment: Alignment.center,
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.primaryColor))),
                                  onTap: functionBox.readDeviceFunc,
                                  dropdownColor: Palette.primaryColor,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedDeviceID = value;
                                      sendDevice = value;
                                    });
                                  },
                                  value: selectedDeviceID,
                                  items: deviceID
                                      .map((e) => DropdownMenuItem(
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  e,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                            value: e,
                                          ))
                                      .toList(),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: TextField(
                                        controller: ipInputController,
                                        onChanged: (text) {
                                          setState(() {});
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'input ip',
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            inputText = ipInputController.text;
                                            influxIp = "http://$inputText:8086";
                                            fireStoreIp =
                                                "http://$inputText:5054";
                                          });
                                        },
                                        style: ButtonStyle(
                                            textStyle:
                                                MaterialStateProperty.all(
                                                    TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.blue)),
                                        child: Text("Apply"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: visibilityMenuMap[1],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Checkbox(
                                          value: isCheckedMap[0],
                                          onChanged: (value) {
                                            setState(() {
                                              functionBox
                                                  .changeIsCheckedLists(0);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text("Temperature")),
                                      Container(
                                        child: Checkbox(
                                          value: isCheckedMap[6],
                                          onChanged: (value) {
                                            setState(() {
                                              functionBox
                                                  .changeIsCheckedLists(6);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text("Ammonia_L"))
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Checkbox(
                                          value: isCheckedMap[1],
                                          onChanged: (value) {
                                            setState(() {
                                              functionBox
                                                  .changeIsCheckedLists(1);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text("Humidity")),
                                      Container(
                                        child: Checkbox(
                                          value: isCheckedMap[7],
                                          onChanged: (value) {
                                            setState(() {
                                              functionBox
                                                  .changeIsCheckedLists(7);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text("Ammonia_M"))
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Checkbox(
                                          value: isCheckedMap[2],
                                          onChanged: (value) {
                                            setState(() {
                                              functionBox
                                                  .changeIsCheckedLists(2);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text("Co2")),
                                      Container(
                                        child: Checkbox(
                                          value: isCheckedMap[8],
                                          onChanged: (value) {
                                            setState(() {
                                              functionBox
                                                  .changeIsCheckedLists(8);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text("Ammonia_H"))
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Checkbox(
                                          value: isCheckedMap[5],
                                          onChanged: (value) {
                                            setState(() {
                                              functionBox
                                                  .changeIsCheckedLists(5);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: Text("Ammonia"))),
                                      Container(
                                        child: Checkbox(
                                          value: isCheckedMap[10],
                                          onChanged: (value) {
                                            setState(() {
                                              functionBox
                                                  .changeIsCheckedLists(10);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text("No2_L"))
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Checkbox(
                                          value: isCheckedMap[3],
                                          onChanged: (value) {
                                            setState(() {
                                              functionBox
                                                  .changeIsCheckedLists(3);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text("Lux")),
                                      Container(
                                        child: Checkbox(
                                          value: isCheckedMap[11],
                                          onChanged: (value) {
                                            setState(() {
                                              functionBox
                                                  .changeIsCheckedLists(11);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text("No2_M"))
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Checkbox(
                                          value: isCheckedMap[4],
                                          onChanged: (value) {
                                            setState(() {
                                              functionBox
                                                  .changeIsCheckedLists(4);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text("Uv")),
                                      Container(
                                        child: Checkbox(
                                          value: isCheckedMap[12],
                                          onChanged: (value) {
                                            setState(() {
                                              functionBox
                                                  .changeIsCheckedLists(12);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text("No2_H"))
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Checkbox(
                                          value: isCheckedMap[9],
                                          onChanged: (value) {
                                            setState(() {
                                              functionBox
                                                  .changeIsCheckedLists(9);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text("No2")),
                                      Container(
                                        child: Checkbox(
                                          value: isCheckedMap[14],
                                          onChanged: (value) {
                                            setState(() {
                                              functionBox
                                                  .changeIsCheckedLists(14);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text("Co_L"))
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Checkbox(
                                          value: isCheckedMap[13],
                                          onChanged: (value) {
                                            setState(() {
                                              functionBox
                                                  .changeIsCheckedLists(13);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text("Co")),
                                      Container(
                                        child: Checkbox(
                                          value: isCheckedMap[15],
                                          onChanged: (value) {
                                            setState(() {
                                              functionBox
                                                  .changeIsCheckedLists(15);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text("Co_M"))
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Checkbox(
                                          value: isCheckedMap[16],
                                          onChanged: (value) {
                                            setState(() {
                                              functionBox
                                                  .changeIsCheckedLists(16);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text("Co_H"))
                                    ]),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  child: RaisedButton(
                                    elevation: 0.0,
                                    color: Colors.lightBlue,
                                    child: Text(
                                      "Sensing Start",
                                      style: Styles.tabTextStyle3,
                                    ),
                                    onPressed: () {
                                      refreshAll();
                                      // for (int i = 0;
                                      //     i < isCheckedMap.length;
                                      //     i++) {
                                      //   if (isCheckedMap[i]) {
                                      //     switch (i) {
                                      //       case 0:
                                      //         refreshTem();
                                      //         break;
                                      //       case 1:
                                      //         refreshHum();
                                      //         break;
                                      //       case 2:
                                      //         refreshCo2();
                                      //         break;
                                      //       case 3:
                                      //         refreshNh3();
                                      //         break;
                                      //       case 4:
                                      //         refreshLux();
                                      //         break;
                                      //       case 5:
                                      //         refreshNo2();
                                      //         break;
                                      //       case 6:
                                      //         refreshCo();
                                      //         break;
                                      //     }
                                      //   }
                                      // }
                                    },
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  child: RaisedButton(
                                    elevation: 0.0,
                                    color: Colors.lightBlue,
                                    child: Text(
                                      "Sensing Stop",
                                      style: Styles.tabTextStyle3,
                                    ),
                                    onPressed: () {
                                      timerSensor1.cancel();
                                      timerSensor2.cancel();
                                      timerSensor3.cancel();
                                      // switch (dropDownSelectedItem) {
                                      //   case "Tem":
                                      //     temTimerStop();
                                      //     break;
                                      //   case "Hum":
                                      //     humTimerStop();
                                      //     break;
                                      //   case "CO2":
                                      //     co2TimerStop();
                                      //     break;
                                      //   case "NH3":
                                      //     nh3TimerStop();
                                      //     break;
                                      //   case "LUX":
                                      //     luxTimerStop();
                                      //     break;
                                      // }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: visibilityMenuMap[2],
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: RaisedButton(
                            elevation: 0.0,
                            color: Colors.lightBlue,
                            onPressed: _showDialog,
                            child: Text(
                              "Open Last Data List",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          );
        });
      },
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: new Text(
              "Error",
              style: TextStyle(fontSize: 20),
            )),
            content: SizedBox(
              height: 40,
              child: Center(
                  child: new Text(
                "\nList is empty",
                style: TextStyle(fontSize: 17),
              )),
            ),
            actions: <Widget>[
              new TextButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "Close",
                    style: TextStyle(fontSize: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      functionBox.changeVisibilityDialogLists(0);
                    });
                  },
                )
              ],
              title: DefaultTabController(
                  length: 5,
                  child: TabBar(
                    labelStyle: Styles.tabTextStyle,
                    labelColor: Palette.primaryColor,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Text("Tem"),
                      Text("Hum"),
                      Text("Co2"),
                      Text("Nh3"),
                      Text("Lux")
                    ],
                    onTap: (index) {
                      switch (index) {
                        case 0:
                          setState(() {
                            functionBox.changeVisibilityDialogLists(0);
                          });
                          break;

                        case 1:
                          setState(() {
                            functionBox.changeVisibilityDialogLists(1);
                          });
                          break;

                        case 2:
                          setState(() {
                            functionBox.changeVisibilityDialogLists(2);
                          });
                          break;

                        case 3:
                          setState(() {
                            functionBox.changeVisibilityDialogLists(3);
                          });
                          break;

                        case 4:
                          setState(() {
                            functionBox.changeVisibilityDialogLists(4);
                          });
                      }
                    },
                  )),
              content: SizedBox());
        });
      },
    );
  }

  void hideGauge() {
    if (homeSelectedItem == "Tem") {
      setState(() {
        functionBox.changeVisibilityLists(0);
        functionBox.changeVisibilityRefreshLists(0);
        functionBox.changeVisibilityOnLists(0);
      });
    } else if (homeSelectedItem == "Hum") {
      setState(() {
        functionBox.changeVisibilityLists(1);
        functionBox.changeVisibilityRefreshLists(1);
        functionBox.changeVisibilityOnLists(1);
      });
    } else if (homeSelectedItem == "CO2") {
      setState(() {
        functionBox.changeVisibilityLists(2);
        functionBox.changeVisibilityRefreshLists(2);
        functionBox.changeVisibilityOnLists(2);
      });
    } else if (homeSelectedItem == "LUX") {
      setState(() {
        functionBox.changeVisibilityLists(4);
        functionBox.changeVisibilityRefreshLists(4);
        functionBox.changeVisibilityOnLists(4);
      });
    } else if (homeSelectedItem == "NH3") {
      setState(() {
        functionBox.changeVisibilityLists(3);
        functionBox.changeVisibilityRefreshLists(3);
        functionBox.changeVisibilityOnLists(3);
      });
    } else if (homeSelectedItem == "NO2") {
      setState(() {
        functionBox.changeVisibilityLists(5);
        functionBox.changeVisibilityRefreshLists(5);
        functionBox.changeVisibilityOnLists(5);
      });
    } else if (homeSelectedItem == "CO") {
      setState(() {
        functionBox.changeVisibilityLists(6);
        functionBox.changeVisibilityRefreshLists(6);
        functionBox.changeVisibilityOnLists(6);
      });
    }

    print(homeSelectedItem);
  }

//UI
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
                      onPressed: () {
                        _showMenu();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_outlined),
                      iconSize: 28.0,
                      color: Colors.white,
                      onPressed: () {
                        reReadInfluxDB();
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
          _buildHeader(screenHeight, screenWidth),
          _buildPreventionTips(screenHeight, screenWidth),
          //_buildInputIp(screenHeight)
        ],
      ),
    );
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
              "데모실 모니터링",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
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

  SliverToBoxAdapter _buildPreventionTips(
      double screenHeight, double screenWidth) {
    return SliverToBoxAdapter(
        child: Column(children: [
      SizedBox(
        height: screenHeight * 0.03,
      ),
      Material(
        elevation: 14.0,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
        shadowColor: Color(0x802196F3),
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
                      Text('재배기 내부 센서',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 25.0))
                  ],
                ),
              ]),
        ),
      ),
      SizedBox(
        height: screenHeight * 0.03,
      ),
      StaggeredGrid.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        children: <Widget>[
          _buildTile(
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
                        if (temSparkLine.isNotEmpty)
                          Text('현재 온도',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueAccent)),
                        if (temSparkLine.isNotEmpty)
                          Text(
                              '${double.parse(temSparkLine.last.toStringAsFixed(2))}°C',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 34.0))
                      ],
                    ),
                  ]),
            ),
          ),
          _buildTile(
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (humSparkLine.isNotEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('현재 습도',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueAccent)),
                          Text(
                              '${double.parse(humSparkLine.last.toStringAsFixed(2))}%',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 34.0))
                        ],
                      ),
                  ]),
            ),
          ),
          _buildTile(
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (luxSparkLine.isNotEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('현재 조도',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueAccent)),
                          Text(
                              '${double.parse(luxSparkLine.last.toStringAsFixed(0))}lm',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 34.0))
                        ],
                      ),
                  ]),
            ),
          ),
          _buildTile(
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (co2SparkLine.isNotEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('현재 CO2',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueAccent)),
                          Text(
                              '${double.parse(co2SparkLine.last.toStringAsFixed(0))}ppm',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 34.0))
                        ],
                      ),
                  ]),
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
                              Stack(
                                children: [
                                  graphText('$temTotalValue°C', 0),
                                  graphText('$humTotalValue%', 1),
                                  graphText('${co2TotalValue}ppm', 2),
                                  graphText('${luxTotalValue}lm', 3),
                                ],
                              ),
                            ],
                          ),
                          DropdownButton(
                              isDense: true,
                              value: actualDropdown,
                              onChanged: (String value) => setState(() {
                                    actualDropdown = value;
                                    beforeActually = value;
                                    switch (value) {
                                      case "온도":
                                        functionBox.changeInAverageLists(0);
                                        break;
                                      case "습도":
                                        functionBox.changeInAverageLists(1);
                                        break;
                                      case "CO2":
                                        functionBox.changeInAverageLists(2);
                                        break;
                                      case "조도":
                                        functionBox.changeInAverageLists(3);
                                        break;
                                    }
                                  }),
                              items: chartDropdownItems.map((String title) {
                                return DropdownMenuItem(
                                  value: title,
                                  child: Text(title,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.0)),
                                );
                              }).toList())
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 4.0)),
                      Stack(
                        children: [
                          graphSpark(temSparkLine, 0),
                          graphSpark(humSparkLine, 1),
                          graphSpark(co2SparkLine, 2),
                          graphSpark(luxSparkLine, 3),
                        ],
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
      SizedBox(
        height: screenHeight * 0.03,
      ),
      Material(
        elevation: 14.0,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
        shadowColor: Color(0x802196F3),
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
                      Text('재배기 외부 센서',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 25.0))
                  ],
                ),
              ]),
        ),
      ),
      SizedBox(
        height: screenHeight * 0.03,
      ),
      StaggeredGrid.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        children: <Widget>[
          _buildTile(
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (tem2SparkLine.isNotEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('현재 온도',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green)),
                          Text(
                              '${double.parse(tem2SparkLine.last.toStringAsFixed(2))}C',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 34.0))
                        ],
                      ),
                  ]),
            ),
          ),
          _buildTile(
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
                        Text('현재 습도',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green)),
                        Text(
                            '${double.parse(hum2SparkLine.last.toStringAsFixed(2))}%',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 34.0))
                      ],
                    ),
                  ]),
            ),
          ),
          _buildTile(
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
                        Text('현재 조도',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green)),
                        Text(
                            '${double.parse(lux2SparkLine.last.toStringAsFixed(2))}lm',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 34.0))
                      ],
                    ),
                  ]),
            ),
          ),
          _buildTile(
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
                        Text('현재 CO2',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green)),
                        Text(
                            '${double.parse(co22SparkLine.last.toStringAsFixed(2))}ppm',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 34.0))
                      ],
                    ),
                  ]),
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
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600)),
                              Stack(
                                children: [
                                  Visibility(
                                    visible: averageOutMap[0],
                                    child: Text('$tem2TotalValue°C',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 34.0)),
                                  ),
                                  Visibility(
                                    visible: averageOutMap[1],
                                    child: Text('$hum2TotalValue%',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 34.0)),
                                  ),
                                  Visibility(
                                    visible: averageOutMap[2],
                                    child: Text('${co22TotalValue}ppm',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 34.0)),
                                  ),
                                  Visibility(
                                    visible: averageOutMap[3],
                                    child: Text('${lux2TotalValue}lm',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 34.0)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          DropdownButton(
                              isDense: true,
                              value: actualDropdown2,
                              onChanged: (String value) => setState(() {
                                    beforeActually2 = value;
                                    actualDropdown2 = value;
                                    switch (value) {
                                      case "온도":
                                        functionBox.changeOutAverageLists(0);
                                        break;
                                      case "습도":
                                        functionBox.changeOutAverageLists(1);
                                        break;
                                      case "CO2":
                                        functionBox.changeOutAverageLists(2);
                                        break;
                                      case "조도":
                                        functionBox.changeOutAverageLists(3);
                                        break;
                                    }
                                  }),
                              items: chartDropdownItems.map((String title) {
                                return DropdownMenuItem(
                                  value: title,
                                  child: Text(title,
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.0)),
                                );
                              }).toList())
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 4.0)),
                      Stack(
                        children: [
                          Visibility(
                            visible: averageOutMap[0],
                            child: Sparkline(
                              data: tem2SparkLine,
                              lineWidth: 5.0,
                              lineColor: Colors.green,
                            ),
                          ),
                          Visibility(
                            visible: averageOutMap[1],
                            child: Sparkline(
                              data: hum2SparkLine,
                              lineWidth: 5.0,
                              lineColor: Colors.green,
                            ),
                          ),
                          Visibility(
                            visible: averageOutMap[2],
                            child: Sparkline(
                              data: co22SparkLine,
                              lineWidth: 5.0,
                              lineColor: Colors.green,
                            ),
                          ),
                          Visibility(
                            visible: averageOutMap[3],
                            child: Sparkline(
                              data: lux2SparkLine,
                              lineWidth: 5.0,
                              lineColor: Colors.green,
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
      SizedBox(
        height: screenHeight * 0.03,
      ),
    ]));
  }

  Visibility graphSpark(List<double> list, int index) {
    return Visibility(
      visible: averageInMap[index],
      child: Sparkline(
        data: list,
        lineWidth: 5.0,
        lineColor: Colors.blueAccent,
      ),
    );
  }

  Visibility graphText(String text, int index) {
    return Visibility(
      visible: averageInMap[index],
      child: Text('$text',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 34.0)),
    );
  }
}

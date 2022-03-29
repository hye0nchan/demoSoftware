// ignore_for_file: deprecated_member_use, unnecessary_statements

import 'dart:async';
import 'dart:io';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcm_notifications/widgets/dashboardWidget.dart';
import 'package:fcm_notifications/widgets/dialogWidget.dart';
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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final List<String> chartDropdownItems = ['온도', '습도', '조도', '이산화탄소'];
  String actualDropdown = "온도";
  String actualDropdown2 = "온도";
  int actualChart = 0;

  var grpc = Grpc();
  var functionBox = FunctionBox();
  var home = MyApp();
  var influxDB = AddInfluxDB();
  var dialog = DialogWidget();

  TextEditingController ipInputController = TextEditingController();

  bool switchValue = true;

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

  //restAPI
  // void getData() async {
  //   http.Response response = await http.get(
  //       Uri.parse('https://172.20.2.87/api/TodoItems/1'),
  //       headers: {"Accept": "application/json"});
  //   Map<String, dynamic> responseBodyMap = jsonDecode(response.body);
  //   print(response.body); // 결과 출력 ==> {"restapi" : "get" }
  //   print(responseBodyMap["gwId"]); // 결과 출력 ==> get
  // }

  void reReadInfluxDB() async {
    for (int i = 0; i < allSensorList.length; i++) {
      var sensorStream = await queryService.query('''
  from(bucket: "farmcare")
  |> range(start: -24h)
  |> filter(fn: (r) => r["_measurement"] == "${allSensorList[i]}")
  |> yield(name: "mean")
  ''');
      if (sensorStream != null) {
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
    }

    if (this.mounted) {
      setState(() {
        temTotalValue = double.parse(
            (temTotalSparkLine / totalTemCount).toStringAsFixed(2));

        tem2TotalValue = double.parse(
            (tem2TotalSparkLine / totalTem2Count).toStringAsFixed(2));

        humTotalValue = double.parse(
            (humTotalSparkLine / totalHumCount).toStringAsFixed(2));

        hum2TotalValue = double.parse(
            (hum2TotalSparkLine / totalHum2Count).toStringAsFixed(2));

        co2TotalValue = double.parse(
            (co2TotalSparkLine / totalCo2Count).toStringAsFixed(2));

        co22TotalValue = double.parse(
            (co22TotalSparkLine / totalCo22Count).toStringAsFixed(2));

        luxTotalValue = double.parse(
            (luxTotalSparkLine / totalLuxCount).toStringAsFixed(2));

        lux2TotalValue = double.parse(
            (lux2TotalSparkLine / totalLux2Count).toStringAsFixed(2));
      });
    }
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
    grpc.sendSensor1();
    getToken();
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
        await f //fireStore에 저장
            .collection('Token')
            .doc('device${fireStoreTokenList.length + 1}')
            .set({'value': token});
      }
    }
    tokenCount = false;
  }

  void changeFunction(int changeNumber) {
    functionBox.changeVisibilityLists(changeNumber);
    functionBox.changeVisibilityRefreshLists(changeNumber);
    functionBox.changeVisibilityOnLists(changeNumber);
  }

//UI
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                iconSize: 28.0,
                color: Colors.white,
                onPressed: () {
                  dialog.homeMenu();
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
              style: Styles.buildHeadStyle,
            ),
          ],
        ),
      ),
    );
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
                      Text('재배기 내부 센서', style: Styles.headLineStyle)
                  ],
                ),
              ]),
        ),
      ),
      SizedBox(
        height: screenHeight * 0.01,
      ),
      StaggeredGrid.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        children: <Widget>[
          homeDataTile1("온도"),
          homeDataTile1("습도"),
          homeDataTile1("조도"),
          homeDataTile1("이산화탄소"),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1,
            child: Material(
              elevation: 14.0,
              borderRadius: BorderRadius.circular(12.0),
              shadowColor: Palette.shadowColor,
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
                              Text('평균 값', style: Styles.graphAverageStyle),
                              Stack(
                                children: [
                                  graphText1('$temTotalValue°C', 0),
                                  graphText1('$humTotalValue%', 1),
                                  graphText1('${co2TotalValue}ppm', 2),
                                  graphText1('${luxTotalValue}lm', 3),
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
                                      case "이산화탄소":
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
                                          fontSize: 17.0)),
                                );
                              }).toList())
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 4.0)),
                      Stack(
                        children: [
                          graphSpark1(temSparkLine, 0),
                          graphSpark1(humSparkLine, 1),
                          graphSpark1(co2SparkLine, 2),
                          graphSpark1(luxSparkLine, 3),
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
                      Text('재배기 외부 센서', style: Styles.headLineStyle)
                  ],
                ),
              ]),
        ),
      ),
      SizedBox(
        height: screenHeight * 0.01,
      ),
      StaggeredGrid.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        children: <Widget>[
          homeDataTile2("온도"),
          homeDataTile2("습도"),
          homeDataTile2("조도"),
          homeDataTile2("이산화탄소"),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1,
            child: Material(
              elevation: 14.0,
              borderRadius: BorderRadius.circular(12.0),
              shadowColor: Palette.shadowColor,
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
                                  graphText2('$tem2TotalValue°C', 0),
                                  graphText2('$hum2TotalValue%', 1),
                                  graphText2('${co22TotalValue}ppm', 2),
                                  graphText2('${lux2TotalValue}lm', 3),
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
                                      case "이산화탄소":
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
                          graphSpark2(tem2SparkLine, 0),
                          graphSpark2(hum2SparkLine, 1),
                          graphSpark2(co22SparkLine, 2),
                          graphSpark2(lux2SparkLine, 3),
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
}

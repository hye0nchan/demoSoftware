// ignore_for_file: unnecessary_statements

import 'dart:async';
import 'dart:io';
import 'package:fcm_notifications/widgets/stats_grid.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:typed_data';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:fcm_notifications/screens/bottom_nav_screen.dart';
import 'data/data.dart';
import 'network.pbgrpc.dart';

//influxDB
void readInfluxDB() async {
  for (int i = 0; i < allSensorList.length; i++) {
    var sensorStream = await queryService.query('''
  from(bucket: "farmcare")
  |> range(start: -24h)
  |> filter(fn: (r) => r["_measurement"] == "${allSensorList[i]}")
  |> yield(name: "mean")
  ''');
    await sensorStream.forEach((record) {
      DateTime date = DateTime.parse(record['_time']);
      var value = record['_value'];

      if (i != 4 && value != 0) {
        sensorChartData[i].add(ChartData(date, value));
        if (i < 3 && i > 0) {
          if (0 < i && i < 2) {
            temSparkLine.add(value);
            temTotalSparkLine += value;
            totalTemCount += 1;
          } else {
            tem2SparkLine.add(value);
            tem2TotalSparkLine += value;
            totalTem2Count += 1;
          }
        }
        if (i < 6 && i > 2) {
          if (2 < i && i < 5) {
            humSparkLine.add(value);
            humTotalSparkLine += value;
            totalHumCount += 1;
          } else {
            hum2SparkLine.add(value);
            hum2TotalSparkLine += value;
            totalHum2Count += 1;
          }
        }
        if (i < 9 && i > 5) {
          if (5 < i && i < 8) {
            co2SparkLine.add(value);
            co2TotalSparkLine += value;
            totalCo2Count += 1;
          } else {
            co22SparkLine.add(value);
            co22TotalSparkLine += value;
            totalCo22Count += 1;
          }
        }
        if (i < 12 && i > 8) {
          if (8 < i && i < 11) {
            luxSparkLine.add(value);
            luxTotalSparkLine += value;
            totalLuxCount += 1;
          } else {
            lux2SparkLine.add(value);
            lux2TotalSparkLine += value;
            totalLux2Count += 1;
          }
        }
      }
    });
  }

  temTotalValue =
      double.parse((temTotalSparkLine / totalTemCount).toStringAsFixed(2));
  temSparkLine.removeAt(0);

  tem2TotalValue =
      double.parse((tem2TotalSparkLine / totalTem2Count).toStringAsFixed(2));
  tem2SparkLine.removeAt(0);

  humTotalValue =
      double.parse((humTotalSparkLine / totalHumCount).toStringAsFixed(2));
  humSparkLine.removeAt(0);

  hum2TotalValue =
      double.parse((hum2TotalSparkLine / totalHum2Count).toStringAsFixed(2));
  hum2SparkLine.removeAt(0);

  co2TotalValue =
      double.parse((co2TotalSparkLine / totalCo2Count).toStringAsFixed(2));
  co2SparkLine.removeAt(0);

  co22TotalValue =
      double.parse((co22TotalSparkLine / totalCo22Count).toStringAsFixed(2));
  co22SparkLine.removeAt(0);

  luxTotalValue =
      double.parse((luxTotalSparkLine / totalLuxCount).toStringAsFixed(2));
  luxSparkLine.removeAt(0);

  lux2TotalValue =
      double.parse((lux2TotalSparkLine / totalLux2Count).toStringAsFixed(2));
  lux2SparkLine.removeAt(0);
}

//foreground
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

//rest API
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  void test(){

  }
}

class _MyAppState extends State<MyApp> {
  String token;

  @override
  void initState() {
    super.initState();
    //receiveMessage();
    readInfluxDB();

    //foreground
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Dashboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: Colors.white),
        home: AnimatedSplashScreen(
          splash: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('imgs/logo.gif'),
              Text(
                "SALTANB\nSMART FARM",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              )
            ],
          ),
          nextScreen: BottomNavScreen(),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.white,
          duration: 3000,
        ));
  }
}

var de = Int64.parseRadix('21A106057F68D', 16);
var gw;
var sequenceNumber;
var grpcChannel;
List<int> da;
var request = RtuMessage();
var response;
final fireStore = FirebaseFirestore.instance;
var device;

Future<ExMessage> receiveMessage() async {
  print("receive");
  ExProtoClient stub = ExProtoClient(ClientChannel(fireStoreIp,
      port: 5044,
      options:
          const ChannelOptions(credentials: ChannelCredentials.insecure())));
  try{
    await for (response in stub.exServerstream(request)) {
      da = response.dataUnit;
      de = response.deviceId;
      gw = response.gwId;
      sequenceNumber = response.sequenceNumber;
      print("test $da");
      device = de;
      displaySensorData(da, device);
    }
  }
  catch(e){
    print('error');
  }


  return response;
}

void displaySensorData(List<int> receiveData, Int64 device) {
  displayEData(da, device);
  print("receive Data : $receiveData");
}


void displayEData(List<int> receiveData, Int64 device) {
  var sensor = "E";
  var bData = ByteData(4);
  List<int> intList = [0, 0, 0, 0];
  List<String> stringList = ["0", "0", "0", "0"];

  for (int i = 0; i < intList.length; i++) {
    intList[i] = receiveData[temList[i]];
    stringList[i] = intList[i].toRadixString(16);
    if (stringList[i].length == 1) {
      stringList[i] = "0${stringList[i]}";
    }
    if (i == 0) {
      stringList[i] = "0x${intList[i].toRadixString(16)}";
    }
  }
  String total =
      "${stringList[21]}${stringList[22]}${stringList[23]}${stringList[24]}";
  int a = int.parse(total);
  bData.setInt32(0, a);
  discernDevice(device, sensor, bData);
}




void discernDevice(var device, var sensor, var bData) {
  switch (sensor) {
    case "E":
      sensor1redEData = bData.getFloat32(0).toStringAsFixed(2);
      print("전압 : $sensor1redEData");
      break;
  }
  sensor1Device = false;
  sensor2Device = false;
  sensor3Device = false;
}

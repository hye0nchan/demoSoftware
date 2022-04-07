// ignore_for_file: unnecessary_statements

import 'dart:async';
import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fcm_notifications/login_page.dart';
import 'package:fcm_notifications/screens/control.dart';
import 'package:fcm_notifications/screens/home_screen.dart';
import 'package:fcm_notifications/screens/info.dart';
import 'package:fcm_notifications/screens/stats_screen.dart';
import 'package:fcm_notifications/widgets/stats_grid.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fcm_notifications/screens/bottom_nav_screen.dart';
import 'data/data.dart';
import 'grpc/grpc.dart';

//influxDB


void readInfluxDB() async {
  for (int i = 0; i < allSensorList.length; i++) {
    var sensorStream = await queryService.query('''
  from(bucket: "farmcare")
  |> range(start: -24h)
  |> filter(fn: (r) => r["_measurement"] == "${allSensorList[i]}")
  |> yield(name: "last")
  ''');
    await sensorStream.forEach((record) {
      DateTime date = DateTime.parse(record['_time']);
      var value = record['_value'];

      //조도일 때
      if (i != 8 && i != 9 && value != 0) {
        sensorChartData[i].add(ChartData(date, value));
        if (i < 2 && i >= 0) {
          if (i==0) {
            temSparkLine.add(value);
            temTotalSparkLine += value;
            totalTemCount += 1;
          } else {
            tem2SparkLine.add(value);
            tem2TotalSparkLine += value;
            totalTem2Count += 1;
          }
        }
        if (i < 4 && i >= 2) {
          if (i==2) {
            humSparkLine.add(value);
            humTotalSparkLine += value;
            totalHumCount += 1;
          } else {
            hum2SparkLine.add(value);
            hum2TotalSparkLine += value;
            totalHum2Count += 1;
          }
        }
        if (i < 6 && i >= 4) {
          if (i==4) {
            co2SparkLine.add(value);
            co2TotalSparkLine += value;
            totalCo2Count += 1;
          } else {
            co22SparkLine.add(value);
            co22TotalSparkLine += value;
            totalCo22Count += 1;
          }
        }
        if (i < 8 && i >= 6) {
          if (i==6) {
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
  if (!Platform.isWindows) {
    screens = [
      HomeScreen(),
      ControlScreen(),
      StatsScreen(),
      Info()
    ];

    await Firebase.initializeApp();
    //background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    HttpOverrides.global = new MyHttpOverrides();
  }
  else{
    print("window");
    screens = [
      HomeScreen(),
      ControlScreen(),
      StatsScreen(),
      LoginPage()
    ];
  }

  runApp(MyApp());
  windowReSize();

}

void windowReSize(){
  final win = appWindow;
  final initialSize = Size(430, 900);
  win.minSize = initialSize;
  win.size = initialSize;
  win.alignment = Alignment.center;
  win.title = "FarmCare";
  win.show();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token;
  var grpc = Grpc();
  @override
  void initState() {
    super.initState();
    readInfluxDB();

    if (!Platform.isWindows) {

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
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
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

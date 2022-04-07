import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:fcm_notifications/grpc/switch.dart';
import 'package:flutter/material.dart';
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
                    Text("test"),
                    Text("test"),
                    Text("test"),
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


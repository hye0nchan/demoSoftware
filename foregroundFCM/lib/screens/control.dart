import 'package:fcm_notifications/grpc/motor.dart';
import 'package:fcm_notifications/grpc/switch.dart';
import 'package:fcm_notifications/widgets/inDialog.dart';
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
                    onMaterial("펌프1", pumpBool),
                    onMaterial("펌프2", pumpBool2),
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
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          settingMaterial(screenHeight, screenWidth,"내부"),
          settingMaterial2(screenHeight, screenWidth, "내부"),
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
                    onMaterial("외부 팬1", outFanBool),
                    onMaterial("외부 팬2", outFanBool2),
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
              settingMaterial(screenHeight, screenWidth,"외부"),
              settingMaterial2(screenHeight, screenWidth, "외부"),
            ],
          ),
    ]));
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
                  case "펌프1":
                    setState(() {
                      pumpBool? switchControl.switchFirstOff("펌프"):
                      switchControl.switchFirstOn("펌프");
                      pumpBool = !pumpBool;

                    });
                    break;
                  case "펌프2":
                    setState(() {
                      pumpBool2? switchControl.switchSecondOff("펌프"):
                      switchControl.switchSecondOn("펌프");
                      pumpBool2 = !pumpBool2;
                    });
                    break;
                  case "전등":
                    setState(() {
                      lampBool? switchControl.switchFirstOff("램프"):
                      switchControl.switchFirstOn("램프");
                      lampBool = !lampBool;
                    });
                    break;
                  case "팬":
                    setState(() {
                      fanBool? switchControl.switchSecondOff("램프"):
                      switchControl.switchSecondOn("램프");
                      fanBool = !fanBool;
                    });
                    break;
                  case "모터":
                    setState(() {
                      motorBool = !motorBool;
                      motorBool? motorControl.motorLeft():
                      motorControl.motorStop();
                    });
                    break;
                  case "외부 팬1":
                    setState(() {
                      outFanBool? switchControl.switchFirstOff("외부 팬"):
                      switchControl.switchFirstOn("외부 팬");
                      outFanBool = !outFanBool;
                    });
                    break;
                  case "외부 팬2":
                    setState(() {
                      outFanBool2? switchControl.switchSecondOff("외부 팬"):
                      switchControl.switchSecondOn("외부 팬");
                      outFanBool2 = !outFanBool2;
                    });
                    break;
                }
              }),
      ],
    );
  }

  Container settingMaterial(double screenHeight, double screenWidth, String inOut) {
    return Container(
      width: screenWidth * 0.47,
      height: screenHeight*0.1,
      child: Material(
        elevation: 14.0,
       borderRadius: BorderRadius.circular(50),
        shadowColor: Palette.shadowColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(child: Text('$inOut 장치 설정', style: Styles.StaggeredGridStyle)),
        ),
      ),
    );
  }

  Container settingMaterial2(double screenHeight, double screenWidth, String inOut) {
    List<String> deviceLists = [];
    (inOut=="내부")?deviceLists = ["펌프","전등","팬"]:deviceLists = ["모터","외부 팬"];
    return Container(
      width: screenWidth * 0.5,
      height: screenHeight*0.1,
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

                  (inOut=="내부")?
                  showDialog(
                      context: context,
                      builder: (_) {
                        return InDialog();
                      })
                      :
                  showDialog(
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

                  (inOut=="내부")?
                  showDialog(
                      context: context,
                      builder: (_) {
                        return InDialog();
                      })
                      :
                  showDialog(
                      context: context,
                      builder: (_) {
                        return OutDialog();
                      });
                },
              ),
              if(inOut=="내부")
              TextButton(
                child: Text(
                  "${deviceLists[2]}",
                  style: Styles.tabSettingTextStyle,
                ),
                onPressed: () {
                  inDialogInitialize = 2;

                  (inOut=="내부")?
                  showDialog(
                      context: context,
                      builder: (_) {
                        return InDialog();
                      })
                      :
                  showDialog(
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

import 'package:flutter/material.dart';
import 'package:fcm_notifications/config/palette.dart';
import 'package:fcm_notifications/data/data.dart';
import 'package:fcm_notifications/data/function.dart';
import 'package:fcm_notifications/grpc/grpc.dart';
import 'package:fcm_notifications/widgets/stats_grid.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  var functionBox = FunctionBox();

  @override
  void initState() {
    super.initState();
  }

  var grpc = Grpc();

  bool barChartVisible = false;
  bool chartVisible = true;

  //influxDB 데이터 가져오는 함수
  void readInfluxDB() async {
    for (int i = 0; i < allSensorList.length; i++) {
      var sensorStream = await queryService.query('''
  from(bucket: "farmcare")
  |> range(start: -1h)
  |> filter(fn: (r) => r["_measurement"] == "${allSensorList[i]}")
  |> yield(name: "mean")
  ''');
      await sensorStream.forEach((record) {
        DateTime date = DateTime.parse(record['_time']);
        var value = record['_value'];
        setState(() {
          if (!sensorChartData[i].contains(ChartData(date, value))) {
            sensorChartData[i].add(ChartData(date, value));
          }
        });
      });
    }
  }

  //UI
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              readInfluxDB();
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
              size: 30,
            ),
          )
        ],
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "FarmCare Dashboard",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
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
          dataChart(screenHeight, context),
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
              "센서 그래프",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter mainBody(double screenHeight, double screenWidth) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.03,
          ),
          Container(
            height: screenHeight * 0.09,
            child: Material(
              elevation: 14.0,
              borderRadius: BorderRadius.circular(30),
              shadowColor: Palette.shadowColor,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        if (temSparkLine.isNotEmpty)
                          Text('센서 선택',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0))
                      ],
                    ),
                    DropdownButton(
                        isDense: true,
                        value: currentSensor,
                        onChanged: (String value) {
                          setState(() {
                            currentSensor = value;

                            switch (value) {
                              case "온도":
                                functionBox
                                    .changeVisibilityStatScreenLists(0);
                                break;
                              case "습도":
                                functionBox
                                    .changeVisibilityStatScreenLists(1);
                                break;
                              case "이산화탄소":
                                functionBox
                                    .changeVisibilityStatScreenLists(2);
                                break;
                              case "조도":
                                functionBox
                                    .changeVisibilityStatScreenLists(3);
                                break;
                              case "자외선":
                                functionBox
                                    .changeVisibilityStatScreenLists(4);
                                break;
                              case "암모니아":
                                functionBox
                                    .changeVisibilityStatScreenLists(5);
                                break;
                              case "이산화질소":
                                functionBox
                                    .changeVisibilityStatScreenLists(6);
                                break;
                              case "일산화탄소":
                                functionBox
                                    .changeVisibilityStatScreenLists(7);
                                break;
                            }

                            //grpc 명령어
                          });
                        },
                        items: graphSensorList.map((String title) {
                          return DropdownMenuItem(
                            value: title,
                            child: Text(title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0)),
                          );
                        }).toList()),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  SliverPadding dataChart(double screenHeight, BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      sliver: SliverToBoxAdapter(
        child: Container(
          height: screenHeight * 0.7,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Stack(
                  children: [
                    //test
                    sensorGraph(0),
                    sensorGraph(1),
                    sensorGraph(2),
                    sensorGraph(3),
                    sensorGraph(4),
                    sensorGraph(5),
                    sensorGraph(6),
                    sensorGraph(7),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Visibility sensorGraph(int index) {
    String chartName = "온도";
    List<ChartData> chartData = [];
    List<ChartData> chartData2 = [];

    switch (index) {
      case 0:
        chartName = "온도";
        chartData = tem1ChartData;
        chartData2 = tem2ChartData;
        break;
      case 1:
        chartName = "습도";
        chartData = hum1ChartData;
        chartData2 = hum2ChartData;
        break;
      case 2:
        chartName = "이산화탄소";
        chartData = co21ChartData;
        chartData2 = co22ChartData;
        break;
      case 3:
        chartName = "조도";
        chartData = lux1ChartData;
        chartData2 = lux2ChartData;
        break;
      case 4:
        chartName = "자외선";
        chartData = uv1ChartData;
        chartData2 = uv2ChartData;
        break;
      case 5:
        chartName = "암모니아";
        chartData = nh31ChartData;
        chartData2 = nh32ChartData;
        break;
      case 6:
        chartName = "이산화질소";
        chartData = no21ChartData;
        chartData2 = no22ChartData;
        break;
      case 7:
        chartName = "일산화탄소";
        chartData = co1ChartData;
        chartData2 = co2ChartData;
        break;
    }
    return Visibility(
      visible: visibilityStatScreenMap[index],
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Material(
          elevation: 14.0,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          shadowColor: Palette.shadowColor,
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
                minimum: firstDate,
                maximum: currentDate,
                intervalType: DateTimeIntervalType.hours,
                interval: 1),
            title: ChartTitle(
              text: "$chartName 차트",
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            series: <ChartSeries<ChartData, DateTime>>[
              LineSeries<ChartData, DateTime>(
                name: "재배기 외부",
                opacity: 0.7,
                width: 4,
                color: Colors.blueAccent,
                dataSource: chartData,
                xValueMapper: (ChartData sales, _) => sales.time,
                yValueMapper: (ChartData sales, _) => sales.value,
              ),
              LineSeries<ChartData, DateTime>(
                name: "재배기 내부",
                opacity: 0.7,
                width: 4,
                color: Colors.redAccent,
                dataSource: chartData2,
                xValueMapper: (ChartData sales, _) => sales.time,
                yValueMapper: (ChartData sales, _) => sales.value,
              ),
            ],
            legend: Legend(isVisible:true),
          ),
        ),
      ),
    );
  }
}

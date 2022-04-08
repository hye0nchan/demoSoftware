import 'dart:async';
import 'dart:typed_data';
import 'package:fcm_notifications/widgets/stats_grid.dart';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:influxdb_client/api.dart';


bool sensorBool = false;
bool pumpBool = false;
bool pumpBool2 = false;
bool lampBool = false;
bool fanBool = false;
bool motorBool = false;
bool motorBool2 = false;
bool outFanBool = false;
bool outFanBool2 = false;
bool boolA = false;



int inDialogInitialize = 0;
int outDialogInitialize = 0;

int currentIndex = 0;

List<String> controlPeriod = [
  "0h",
  "1h",
  "2h",
  "3h",
  "4h",
  "5h",
  "6h",
  "7h",
  "8h",
  "9h"
];
String pumpInitialize = "1h";
String lampInitialize = "1h";
String fanInitialize = "1h";
String motorInitialize = "1h";
String outFanInitialize = "1h";

String currentSensor = "온도";
List<String> graphSensorList = [
  "온도",
  "습도",
  "이산화탄소",
  "조도",
  "자외선",
  "암모니아",
  "이산화질소",
  "일산화탄소",
];

int homeMenuInitialize = 0;

var tokenCount = true;
////////////////////////////////////////////////////////////////////////////////
// influxDB

var influxIp = "http://172.20.2.72:8086";
var inputText = "test";
var client = InfluxDBClient(
    url: influxIp,
    token:
        'jrGSUa8nVpoSqLvIpqebtcgXPsu3cyh6nlCWVUFHf8Sa1FsE5sVsNXXEa-3X-y4KsO0iyb8e6MICbPxOMt5dyg==',
    org: 'saltanb',
    bucket: 'farmcare',
    debug: true);
var writeApi = WriteService(client);
var queryService = client.getQueryService();

var sensor1redVData = "0";
var sensor1redAData = "0";

var sensor1redTemData = "0";
var sensor1redHumData = "0";
var sensor1redCo2Data = "0";
var sensor1redLuxData = "0";
var sensor1redUvData = "0";
var sensor1redNh3Data = "0";
var sensor1redNh3LData = "0";
var sensor1redNh3MData = "0";
var sensor1redNh3HData = "0";
var sensor1redNo2Data = "0";
var sensor1redNo2LData = "0";
var sensor1redNo2MData = "0";
var sensor1redNo2HData = "0";
var sensor1redCoData = "0";
var sensor1redCoLData = "0";
var sensor1redCoMData = "0";
var sensor1redCoHData = "0";

var sensor2redTemData = "0";
var sensor2redHumData = "0";
var sensor2redCo2Data = "0";
var sensor2redLuxData = "0";
var sensor2redUvData = "0";
var sensor2redNh3Data = "0";
var sensor2redNh3LData = "0";
var sensor2redNh3MData = "0";
var sensor2redNh3HData = "0";
var sensor2redNo2Data = "0";
var sensor2redNo2LData = "0";
var sensor2redNo2MData = "0";
var sensor2redNo2HData = "0";
var sensor2redCoData = "0";
var sensor2redCoLData = "0";
var sensor2redCoMData = "0";
var sensor2redCoHData = "0";

var sensor3redTemData = "0";
var sensor3redHumData = "0";
var sensor3redCo2Data = "0";
var sensor3redLuxData = "0";
var sensor3redUvData = "0";
var sensor3redNh3Data = "0";
var sensor3redNh3LData = "0";
var sensor3redNh3MData = "0";
var sensor3redNh3HData = "0";
var sensor3redNo2Data = "0";
var sensor3redNo2LData = "0";
var sensor3redNo2MData = "0";
var sensor3redNo2HData = "0";
var sensor3redCoData = "0";
var sensor3redCoLData = "0";
var sensor3redCoMData = "0";
var sensor3redCoHData = "0";

bool readCount = true;
bool sensor1Device = false;
bool sensor2Device = false;
bool sensor3Device = false;

DateTime currentDate = DateTime.now();
DateTime firstDate = currentDate.subtract(Duration(hours: 24));

List<String> allSensorList = [
  "tem_1",
  "tem_2",
  "hum_1",
  "hum_2",
  "co2_1",
  "co2_2",
  "lux_1",
  "lux_2",
  "uv_1",
  "uv_2",
  "nh3_1",
  "nh3_2",
  "nh3L_1",
  "nh3L_2",
  "nh3M_1",
  "nh3M_2",
  "nh3H_1",
  "nh3H_2",
  "no2_1",
  "no2_2",
  "no2L_1",
  "no2L_2",
  "no2M_1",
  "no2M_2",
  "no2H_1",
  "no2H_2",
  "co_1",
  "co_2",
  "coL_1",
  "coL_2",
  "coM_1",
  "coM_2",
  "coH_1",
  "coH_2",
];

List<ChartData> tem1ChartData = [];
List<ChartData> tem2ChartData = [];
List<ChartData> tem3ChartData = [];
List<ChartData> hum1ChartData = [];
List<ChartData> hum2ChartData = [];
List<ChartData> hum3ChartData = [];
List<ChartData> co21ChartData = [];
List<ChartData> co22ChartData = [];
List<ChartData> co23ChartData = [];
List<ChartData> lux1ChartData = [];
List<ChartData> lux2ChartData = [];
List<ChartData> lux3ChartData = [];
List<ChartData> uv1ChartData = [];
List<ChartData> uv2ChartData = [];
List<ChartData> uv3ChartData = [];
List<ChartData> nh31ChartData = [];
List<ChartData> nh32ChartData = [];
List<ChartData> nh33ChartData = [];
List<ChartData> nh3L1ChartData = [];
List<ChartData> nh3L2ChartData = [];
List<ChartData> nh3L3ChartData = [];
List<ChartData> nh3M1ChartData = [];
List<ChartData> nh3M2ChartData = [];
List<ChartData> nh3M3ChartData = [];
List<ChartData> nh3H1ChartData = [];
List<ChartData> nh3H2ChartData = [];
List<ChartData> nh3H3ChartData = [];
List<ChartData> no21ChartData = [];
List<ChartData> no22ChartData = [];
List<ChartData> no23ChartData = [];
List<ChartData> no2L1ChartData = [];
List<ChartData> no2L2ChartData = [];
List<ChartData> no2L3ChartData = [];
List<ChartData> no2M1ChartData = [];
List<ChartData> no2M2ChartData = [];
List<ChartData> no2M3ChartData = [];
List<ChartData> no2H1ChartData = [];
List<ChartData> no2H2ChartData = [];
List<ChartData> no2H3ChartData = [];
List<ChartData> co1ChartData = [];
List<ChartData> co2ChartData = [];
List<ChartData> co3ChartData = [];
List<ChartData> coL1ChartData = [];
List<ChartData> coL2ChartData = [];
List<ChartData> coL3ChartData = [];
List<ChartData> coM1ChartData = [];
List<ChartData> coM2ChartData = [];
List<ChartData> coM3ChartData = [];
List<ChartData> coH1ChartData = [];
List<ChartData> coH2ChartData = [];
List<ChartData> coH3ChartData = [];

List<List<ChartData>> sensorChartData = [
  tem1ChartData,
  tem2ChartData,
  hum1ChartData,
  hum2ChartData,
  co21ChartData,
  co22ChartData,
  lux1ChartData,
  lux2ChartData,
  uv1ChartData,
  uv2ChartData,
  nh31ChartData,
  nh32ChartData,
  nh3L1ChartData,
  nh3L2ChartData,
  nh3M1ChartData,
  nh3M2ChartData,
  nh3H1ChartData,
  nh3H2ChartData,
  no21ChartData,
  no22ChartData,
  no2L1ChartData,
  no2L2ChartData,
  no2M1ChartData,
  no2M2ChartData,
  no2H1ChartData,
  no2H2ChartData,
  co1ChartData,
  co2ChartData,
  coL1ChartData,
  coL2ChartData,
  coL3ChartData,
  coM1ChartData,
  coM2ChartData,
  coH1ChartData,
  coH2ChartData,
];

double temTotalSparkLine = 0;
double humTotalSparkLine = 0;
double co2TotalSparkLine = 0;
double luxTotalSparkLine = 0;

double temTotalValue = 0;
double humTotalValue = 0;
double co2TotalValue = 0;
double luxTotalValue = 0;

double tem2TotalSparkLine = 0;
double hum2TotalSparkLine = 0;
double co22TotalSparkLine = 0;
double lux2TotalSparkLine = 0;

double tem2TotalValue = 0;
double hum2TotalValue = 0;
double co22TotalValue = 0;
double lux2TotalValue = 0;

var totalTemCount = 0;
var totalHumCount = 0;
var totalCo2Count = 0;
var totalLuxCount = 0;

var totalTem2Count = 0;
var totalHum2Count = 0;
var totalCo22Count = 0;
var totalLux2Count = 0;

String beforeActually = "온도";
String beforeActually2 = "온도";

List<double> temSparkLine = [0];
List<double> humSparkLine = [0];
List<double> co2SparkLine = [0];
List<double> luxSparkLine = [0];

List<double> tem2SparkLine = [0];
List<double> hum2SparkLine = [0];
List<double> co22SparkLine = [0];
List<double> lux2SparkLine = [0];

bool homeDispose = false;

List<String> sensorList = [
  "tem_1",
  "tem_2",
  "tem_3",
  "hum_1",
  "hum_2",
  "hum_3",
  "co2_1",
  "co2_2",
  "co2_3",
  "lux_1",
  "lux_2",
  "lux_3",
  "uv_1",
  "uv_2",
  "uv_3",
  "nh3_1",
  "nh3_2",
  "nh3_3",
  "nh3L_1",
  "nh3L_2",
  "nh3L_3",
  "nh3M_1",
  "nh3M_2",
  "nh3M_3",
  "nh3H_1",
  "nh3H_2",
  "nh3H_3",
  "no2_1",
  "no2_2",
  "no2_3",
  "no2L_1",
  "no2L_2",
  "no2L_3",
  "no2M_1",
  "no2M_2",
  "no2M_3",
  "no2H_1",
  "no2H_2",
  "no2H_3",
  "co_1",
  "co_2",
  "co_3",
  "coL_1",
  "coL_2",
  "coL_3",
  "coM_1",
  "coM_2",
  "coM_3",
  "coH_1",
  "coH_2",
  "coH_3",
];
////////////////////////////////////////////////////////////////////////////////
//grpc
double temValue = 0;
double humValue = 0;
double co2Value = 0;
double uvValue = 0;
double luxValue = 0;

double tem2Value = 0;
double hum2Value = 0;
double co22Value = 0;
double lux2Value = 0;

double nh3Value = 0;
double nh3LValue = 0;
double nh3MValue = 0;
double nh3HValue = 0;
double no2Value = 0;
double no2LValue = 0;
double no2MValue = 0;
double no2HValue = 0;
double coValue = 0;
double coLValue = 0;
double coMValue = 0;
double coHValue = 0;
String nullTem = "";
String nullHum = "";
String nullCo2 = "";
String nullLux = "";
String nullUv = "";
String nullNh3 = "";
String nullNh3L = "";
String nullNh3M = "";
String nullNh3H = "";
String nullNo2 = "";
String nullNo2L = "";
String nullNo2M = "";
String nullNo2H = "";
String nullCo = "";
String nullCoL = "";
String nullCoM = "";
String nullCoH = "";

List<int> vList = [23, 24, 21, 22];
List<int> aList = [15, 16, 13, 14];

List<int> temList = [23, 24, 21, 22];
List<int> humList = [5, 6, 3, 4];
List<int> co2List = [29, 30, 27, 28];
List<int> luxList = [35, 36, 33, 34];
List<int> uvList = [41, 42, 39, 40];
List<int> nh3List = [47, 48, 45, 46];
List<int> nh3LList = [65, 66, 63, 64];
List<int> nh3MList = [71, 72, 69, 70];
List<int> nh3HList = [77, 78, 75, 76];
List<int> no2List = [53, 54, 51, 52];
List<int> no2LList = [95, 96, 93, 94];
List<int> no2MList = [107, 108, 105, 106];
List<int> no2HList = [113, 114, 111, 112];
List<int> coList = [59, 60, 57, 58];
List<int> coLList = [31, 132, 129, 130];
List<int> coMList = [137, 138, 135, 136];
List<int> coHList = [49, 150, 147, 148];

List screens = [];


var motorDevice1 = Int64.parseInt(int.parse(("0x" + "500291AEBEF1")).toString());
var motorDevice2 = Int64.parseInt(int.parse(("0x" + "4C7525C1CF8D")).toString());
var motorDevice3 = Int64.parseInt(int.parse(("0x" + "4C75258912F5")).toString());

var motorDevice = Int64.parseInt(int.parse(("0x" + "4C7525C1CF89")).toString());

List<String> deviceList = ["4C7525C1CF89","4C7525C1CF8D","4C75258912F5"];

int opId = 0x00;
Uint8List uInt8OpId = Uint8List(opId);
Uint8List byteOpId = Uint8List(opId>>8);
int gatewayAddress = 0;
int deviceAddress = 0x4C7525C1CF89;
int deviceAddress2 = 0x4C7525C1CF81;

bool eTrue = false;

bool eValue = false;

num sendGateway = 0;
num sendDevice = 0x24A16057F685;

Timer timerSensor1;
Timer timerSensor2;
Timer timerSensor3;

Int64 hexDevice;
var sendDeviceId;
String stringGateway;
int hexGateway;
String stringDevice;
String intDevice;

String selectedGateway = gatewayID[0];
String selectedDeviceID = deviceID[0];

List<String> gatewayID = ["01", "02"];
List<String> deviceID = ["24A16057F685", "0x500291AEBCD9", "500291AEBE4D"];
////////////////////////////////////////////////////////////////////////////////
// material
List<String> dropDownItem = [
  "Tem",
  "Hum",
  "CO2",
  "LUX",
  "UV",
  "NH3",
  "NO2",
  "CO",
];

List<String> dropDownItem2 = [
  "NH3_L",
  "NH3_M",
  "NH3_H",
  "NO2_L",
  "NO2_M",
  "NO2_H",
  "CO_L",
  "CO_M",
  "CO_H"
];

List<String> saveGateway = [];
List<String> saveDevice = [];

TextEditingController gatewayController = TextEditingController();
TextEditingController deviceController = TextEditingController();

String homeHolder = "Tem";
String homeHolder2 = "Tem";
String homeSelectedItem = "Tem";
String homeSelectedItem2 = "NH3_L";

String dropdownRecycleItem = "Tem";

String statHolder = "Tem";

String dropDownSelectedItem = "Tem";
String recyclePeriod = "5s";
int intRecyclePeriod = 10;
String dateHolder = "Tem";
String dateSelectedItem = "Tem";
////////////////////////////////////////////////////////////////////////////////
//firestore

List<String> fireStoreTokenList = [];
String fireStoreIp = "172.20.2.72";
////////////////////////////////////////////////////////////////////////////////
//Map
Map<int, bool> isCheckedMap = {
  0: false, //온도
  1: false, //습도
  2: false, //이산화탄소
  3: false, //조도
  4: false, //자외선
  5: false, //암모니아
  6: false, //암모니아L
  7: false, //암모니아M
  8: false, //암모니아H
  9: false, //이산화질소
  10: false, //이산화질소L
  11: false, //이산화질소M
  12: false, //이산화질소H
  13: false, //일산화탄소
  14: false, //일산화탄소L
  15: false, //일산화탄소M
  16: false, //일산화탄소H
};

Map<int, bool> visibilityOnMap = {
  0: true,
  1: false,
  2: false,
  3: false,
  4: false,
  5: false,
  6: false,
};

Map<int, bool> visibilityMap = {
  0: true,
  1: false,
  2: false,
  3: false,
  4: false,
  5: false,
  6: false,
};

Map<int, bool> averageInMap = {
  0: true,
  1: false,
  2: false,
  3: false,
};

Map<int, bool> averageOutMap = {
  0: true,
  1: false,
  2: false,
  3: false,
};

Map<int, bool> visibilityRefreshMap = {
  0: true,
  1: false,
  2: false,
  3: false,
  4: false,
  5: false,
  6: false,
};

Map<int, bool> visibilityDialogMap = {
  0: true,
  1: false,
  2: false,
  3: false,
  4: false,
  5: false,
  6: false,
};

Map<int, bool> visibilityStatScreenMap = {
  0: true,
  1: false,
  2: false,
  3: false,
  4: false,
  5: false,
  6: false,
  7: false,
};

Map<int, bool> visibilityMenuMap = {
  0: true,
  1: false,
  2: false,
};

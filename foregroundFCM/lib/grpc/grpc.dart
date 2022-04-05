// ignore_for_file: unnecessary_statements


import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:fcm_notifications/network.pbgrpc.dart';
import '../data/data.dart';

class Grpc {
  //전송 레지스터 값

  // 0x24A16057F685
  // 1번 : 습도 / 00CB
  // 4번 : 온도 / 00D4
  // 5번 : 이산화탄소 / 00D7
  // 6번 : 조도 / 00DA
  // 7번 : 자외선 / 00DD
  // 8번 : 암모니아 / 00E0
  // 9번 : 이산화질소 / 00e3
  // 10번 : 일산화탄소 / 00E6
  // 11번 : 암모니아센서_L / 00E9
  // 12번 : 암모니아센서_M / 00EC
  // 13번 : 암모니아센서_H / 00EF
  // 16 : 이산화질소센서_L / 00F8
  // 18 : 이산화질소센서_M / 00fe
  // 19 : 이산화질소센서_H / FF02
  // 22 : 일산화탄소_L / FF0B
  // 23 : 일산화탄소_M / FF0E
  // 24 : 일산화탄소_H / FF11

  //1번 주소 0x24A16057F685
  //2번 주소 0x500291AEBCD9
  //3번 주소 0x500291AEBE4D

  List<int> sensorResiter = [0x01, 0x03, 0xCB, 0x52];
  List<int> temResiter = [0x01, 0x03, 0xD4, 0x04];
  List<int> humResiter = [0x01, 0x03, 0xCB, 0x04];
  List<int> co2Resiter = [0x01, 0x03, 0xD7, 0x04];
  List<int> luxResiter = [0x01, 0x03, 0xDA, 0x04];
  List<int> uvResiter = [0x01, 0x03, 0xDD, 0x04];
  List<int> nh3Resiter = [0x01, 0x03, 0xE0, 0x04];
  List<int> nh3LResiter = [0x01, 0x03, 0xE9, 0x04];
  List<int> nh3MResiter = [0x01, 0x03, 0xEC, 0x04];
  List<int> nh3HResiter = [0x01, 0x03, 0xEF, 0x04];
  List<int> no2Resiter = [0x01, 0x03, 0xE3, 0x04];
  List<int> no2LResiter = [0x01, 0x03, 0xF8, 0x04];
  List<int> no2MResiter = [0x01, 0x03, 0xfe, 0x04];
  List<int> no2HResiter = [0x01, 0x03, 0x02, 0x04];
  List<int> coResiter = [0x01, 0x03, 0xE6, 0x04];
  List<int> coLResiter = [0x01, 0x03, 0x0B, 0x04];
  List<int> coMResiter = [0x01, 0x03, 0x0E, 0x04];
  List<int> coHResiter = [0x01, 0x03, 0x11, 0x04];


  ExProtoClient stub;

  final box = new RtuMessage();


  Future<RtuMessage> sensingV() async {
    boolA = true;
    var protocol = 200;
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5044,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));

    try {
      await stub.exClientstream(box
        ..channel = protocol
        ..sequenceNumber = 0
        ..gwId = 0
        ..dataUnit = [0x01, 0x03, 0x00, 203, 0x00, 13, 0xAD, 0xDE]
        ..deviceId = motorDevice3);
      opId++;
      return (box);
    }
    catch(e){
      print("error");
    }
    return box;
  }

  Future<RtuMessage> sendSensor1() async {
    var protocol = 200;
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5044,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    await stub.exClientstream(box
      ..channel = protocol
      ..sequenceNumber = 0
      ..gwId = 0
      ..dataUnit = [
        sensorResiter[0],
        sensorResiter[1],
        0x00,
        sensorResiter[2],
        0x00,
        sensorResiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = motorDevice3);
    return (box);
  }

  Future<RtuMessage> sendSensor2() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    await stub.exClientstream(box
      ..channel = 200
      ..sequenceNumber = 0
      ..gwId = 0
      ..dataUnit = [
        sensorResiter[0],
        sensorResiter[1],
        0x00,
        sensorResiter[2],
        0x00,
        sensorResiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = device);
    return (box);
  }

  Future<RtuMessage> sendSensor3() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    await stub.exClientstream(box
      ..channel = 200
      ..sequenceNumber = 0
      ..gwId = 0
      ..dataUnit = [
        sensorResiter[0],
        sensorResiter[1],
        0x00,
        sensorResiter[2],
        0x00,
        sensorResiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = device);
    return (box);
  }

  //--------------------------------------------------- ExServerStream --------------------------------------------------//

  String data;
  String gateway;
  var ro;
  var de = Int64.parseRadix('21A106057F68D', 16);
  var gw;
  var sequenceNumber;
  var grpcChannel;
  List<int> da;
  var request = RtuMessage();
  var response;
  var device;

  Future<RtuMessage> receiveMessage() async {
    print("receive");
    ExProtoClient stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5044,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    await for (response in stub.exServerstream(request)) {
      da = response.dataUnit;
      de = response.deviceId;
      gw = response.gwId;

      device = de;

      print("receive Complete");

      if(boolA){
        displaySensorData(da, device);
        boolA = false;
      }
    }
    return response;

  }

  void displaySensorData(List<int> receiveData, Int64 device) {
    displayVData(da, device);
    displayAData(da, device);
  }

  void displayVData(List<int> receiveData, Int64 device) {
    var sensor = "V";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[vList[i]];
      stringList[i] = intList[i].toRadixString(16);
      if (stringList[i].length == 1) {
        stringList[i] = "0${stringList[i]}";
      }
      if (i == 0) {
        stringList[i] = "0x${intList[i].toRadixString(16)}";
      }
    }
    String total =
        "${stringList[0]}${stringList[1]}${stringList[2]}${stringList[3]}";
    int a = int.parse(total);
    bData.setInt32(0, a);
    discernDevice(device, sensor, bData);
  }

  void displayAData(List<int> receiveData, Int64 device) {
    var sensor = "A";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[aList[i]];
      stringList[i] = intList[i].toRadixString(16);
      if (stringList[i].length == 1) {
        stringList[i] = "0${stringList[i]}";
      }
      if (i == 0) {
        stringList[i] = "0x${intList[i].toRadixString(16)}";
      }
    }
    String total =
        "${stringList[0]}${stringList[1]}${stringList[2]}${stringList[3]}";
    int a = int.parse(total);
    bData.setInt32(0, a);
    discernDevice(device, sensor, bData);
  }

  void discernDevice(var device, var sensor, var bData) {
    switch (sensor) {
      case "V":
        sensor1redVData = bData.getFloat32(0).toStringAsFixed(2);
          print("V : $sensor1redVData");
        break;

      case "A":
        sensor1redAData = bData.getFloat32(0).toStringAsFixed(2);
        print("A : $sensor1redAData");
        break;
    }
  }

}

// ignore_for_file: unnecessary_statements

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:fcm_notifications/network.pbgrpc.dart';
import 'data.dart';

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

  //임의 값
  List<int> pumpResister = [0x00, 0x00, 0x00, 0x00];
  List<int> lampResister = [0x00, 0x00, 0x00, 0x00];

  List<int> fanResister = [0x00, 0x00, 0x00, 0x00];

  //motor 제어

  //fireStore 선언



  //IP 가져오기
  void getIp() {
    if(Platform.isWindows){
      final fireStore = FirebaseFirestore.instance;

    fireStore.collection("IP").get().then((QuerySnapshot ds) {
      ds.docs.forEach((doc) {
        fireStoreIp = doc["IP"];
      });
      print("test1$fireStoreIp");
    });
    print("out loop$fireStoreIp");
    fireStoreIp = inputText;
  }
  }

  //DeviceId, Gateway 변수 선언

  //DeviceId Int64로 형변형
  void deviceSubmitted() {
    stringDevice = "0x" + "500291AEBCD9";
    String intDevice = int.parse(stringDevice).toString();
    hexDevice = Int64.parseInt(intDevice);
    sendDeviceId = hexDevice;
  }

  ExProtoClient stub;

  //현재 값 0임
  var ga1 = 0;

  void gatewaySubmitted() {
    stringGateway = "0x" + selectedGateway;
    hexGateway = int.parse(stringGateway);
    //sendGateway = hexGateway;
    sendGateway = 0;
  }

  final box = new RtuMessage();

  Future<RtuMessage> controlPump() async {
    var protocol = 200;
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    await stub.exClientstream(box
      ..channel = protocol
      ..sequenceNumber = 0
      ..gwId = 0
      ..dataUnit = [
        pumpResister[0],
        pumpResister[1],
        0x00,
        pumpResister[2],
        0x00,
        pumpResister[3],
        0xAD,
        0xDE
      ]
      ..deviceId = de1);
    return (box);
  }

  Future<RtuMessage> controlLamp() async {
    var protocol = 200;
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    await stub.exClientstream(box
      ..channel = protocol
      ..sequenceNumber = 0
      ..gwId = 0
      ..dataUnit = [
        lampResister[0],
        lampResister[1],
        0x00,
        lampResister[2],
        0x00,
        lampResister[3],
        0xAD,
        0xDE
      ]
      ..deviceId = de1);
    return (box);
  }

  Future<RtuMessage> controlFan() async {
    var protocol = 200;
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    await stub.exClientstream(box
      ..channel = protocol
      ..sequenceNumber = 0
      ..gwId = 0
      ..dataUnit = [
        fanResister[0],
        fanResister[1],
        0x00,
        fanResister[2],
        0x00,
        fanResister[3],
        0xAD,
        0xDE
      ]
      ..deviceId = de1);
    return (box);
  }

  Future<RtuMessage> sensingE() async {
    boolE = true;
    var protocol = 200;
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5044,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    await stub.exClientstream(box
      ..channel = protocol
      ..sequenceNumber = 0
      ..gwId = 0
      ..dataUnit = [0x01, 0x03, 0x00, 203, 0x00, 13, 0xAD, 0xDE]
      ..deviceId = motorDevice);
    opId++;
    return (box);
  }

  Future<RtuMessage> motorStop() async {
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
        0x01,
        0x10,
        0x01,
        0xF7,
        0x00,
        0x04,
        0x08,
        0x00,
        0x00,
        opId >> 8,
        opId,
        0x00,
        0x00,
        0x00,
        0x00,
        0xAD,
        0xDE
      ]
      ..deviceId = motorDevice);
    opId++;
    return (box);
  }

  Future<RtuMessage> motorLeft() async {
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
        0x01,
        0x10,
        0x01,
        0xF7,
        0x00,
        0x04,
        0x08,
        0x01,
        0x2d,
        opId >> 8,
        opId,
        0x00,
        0x00,
        0x00,
        0x00,
        0xAD,
        0xDE
      ]
      ..deviceId = motorDevice2);
    opId++;
    return (box);
  }

  Future<RtuMessage> motorRight() async {
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
        0x01,
        0x10,
        0x01,
        0xF7,
        0x00,
        0x04,
        0x08,
        0x01,
        0x2e,
        opId >> 8,
        opId,
        0x00,
        0x00,
        0x00,
        0x00,
        0xAD,
        0xDE
      ]
      ..deviceId = motorDevice2);
    opId++;
    return (box);
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
      ..deviceId = sensorDevice3);
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
      ..deviceId = de2);
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
      ..deviceId = de3);
    return (box);
  }

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
      displaySensorData(da, device);
    }
    return response;
  }

  void displaySensorData(List<int> receiveData, Int64 device) {
    if(boolE){
      displayEData(da, device);
    }
  }

  void displayEData(List<int> receiveData, Int64 device) {
    var sensor = "E";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[eList[i]];
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

  void displayTemData(List<int> receiveData, Int64 device) {
    var sensor = "tem";
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
        "${stringList[0]}${stringList[1]}${stringList[2]}${stringList[3]}";
    int a = int.parse(total);
    bData.setInt32(0, a);
    print(bData);
    discernDevice(device, sensor, bData);
  }

  void displayHumData(List<int> receiveData, Int64 device) {
    var sensor = "hum";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[humList[i]];
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

  void displayCo2Data(List<int> receiveData, Int64 device) {
    var sensor = "co2";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[co2List[i]];
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

  void displayLuxData(List<int> receiveData, Int64 device) {
    var sensor = "lux";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[luxList[i]];
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

  void displayUvData(List<int> receiveData, Int64 device) {
    var sensor = "uv";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[uvList[i]];
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

  void displayNh3Data(List<int> receiveData, Int64 device) {
    var sensor = "nh3";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[nh3List[i]];
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

  void displayNh3LData(List<int> receiveData, Int64 device) {
    var sensor = "nh3L";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[nh3LList[i]];
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

  void displayNh3MData(List<int> receiveData, Int64 device) {
    var sensor = "nh3M";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[nh3MList[i]];
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

  void displayNh3HData(List<int> receiveData, Int64 device) {
    var sensor = "nh3H";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[nh3HList[i]];
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

  void displayNo2Data(List<int> receiveData, Int64 device) {
    var sensor = "no2";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[no2List[i]];
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

  void displayNo2LData(List<int> receiveData, Int64 device) {
    var sensor = "no2L";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[no2LList[i]];
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

  void displayNo2MData(List<int> receiveData, Int64 device) {
    var sensor = "no2M";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[no2MList[i]];
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

  void displayNo2HData(List<int> receiveData, Int64 device) {
    var sensor = "no2H";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[no2HList[i]];
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

  void displayCoData(List<int> receiveData, Int64 device) {
    var sensor = "co";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[coList[i]];
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

  void displayCoLData(List<int> receiveData, Int64 device) {
    var sensor = "coL";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[coLList[i]];
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

  void displayCoMData(List<int> receiveData, Int64 device) {
    var sensor = "coM";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[coMList[i]];
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

  void displayCoHData(List<int> receiveData, Int64 device) {
    var sensor = "coH";
    var bData = ByteData(4);
    List<int> intList = [0, 0, 0, 0];
    List<String> stringList = ["0", "0", "0", "0"];

    for (int i = 0; i < intList.length; i++) {
      intList[i] = receiveData[coHList[i]];
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
      case "E":
        sensor1redEData = bData.getFloat32(0).toStringAsFixed(2);
          print("E : $sensor1redEData");
          boolE = false;
        break;
    }
  }

  Future<RtuMessage> sendTemperature() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    deviceSubmitted();
    await stub.exClientstream(box
      ..channel = 0
      ..sequenceNumber = 0
      ..gwId = 0
      ..dataUnit = [
        temResiter[0],
        temResiter[1],
        0x00,
        temResiter[2],
        0x00,
        temResiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = sendDeviceId);
    return (box);
  }

  Future<RtuMessage> sendHumidity() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    deviceSubmitted();
    await stub.exClientstream(box
      ..sequenceNumber = 1
      ..gwId = ga1
      ..dataUnit = [
        humResiter[0],
        humResiter[1],
        0x00,
        humResiter[2],
        0x00,
        humResiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = sendDeviceId);
    return (box);
  }

  Future<RtuMessage> sendCo2() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    deviceSubmitted();
    await stub.exClientstream(box
      ..sequenceNumber = 2
      ..gwId = ga1
      ..dataUnit = [
        co2Resiter[0],
        co2Resiter[1],
        0x00,
        co2Resiter[2],
        0x00,
        co2Resiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = sendDeviceId);
    return (box);
  }

  Future<RtuMessage> sendLux() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    deviceSubmitted();
    await stub.exClientstream(box
      ..sequenceNumber = 3
      ..gwId = ga1
      ..dataUnit = [
        luxResiter[0],
        luxResiter[1],
        0x00,
        luxResiter[2],
        0x00,
        luxResiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = sendDeviceId);
    return (box);
  }

  Future<RtuMessage> sendUv() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    deviceSubmitted();
    await stub.exClientstream(box
      ..gwId = ga1
      ..dataUnit = [
        uvResiter[0],
        uvResiter[1],
        0x00,
        uvResiter[2],
        0x00,
        uvResiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = sendDeviceId);
    return (box);
  }

  Future<RtuMessage> sendNh3() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    deviceSubmitted();
    await stub.exClientstream(box
      ..gwId = ga1
      ..dataUnit = [
        nh3Resiter[0],
        nh3Resiter[1],
        0x00,
        nh3Resiter[2],
        0x00,
        nh3Resiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = sendDeviceId);
    return (box);
  }

  Future<RtuMessage> sendNh3L() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    deviceSubmitted();
    await stub.exClientstream(box
      ..gwId = ga1
      ..dataUnit = [
        nh3LResiter[0],
        nh3LResiter[1],
        0x00,
        nh3LResiter[2],
        0x00,
        nh3LResiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = sendDeviceId);
    return (box);
  }

  Future<RtuMessage> sendNh3M() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    deviceSubmitted();
    await stub.exClientstream(box
      ..gwId = ga1
      ..dataUnit = [
        nh3MResiter[0],
        nh3MResiter[1],
        0x00,
        nh3MResiter[2],
        0x00,
        nh3MResiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = sendDeviceId);
    return (box);
  }

  Future<RtuMessage> sendNh3H() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    deviceSubmitted();
    await stub.exClientstream(box
      ..gwId = ga1
      ..dataUnit = [
        nh3HResiter[0],
        nh3HResiter[1],
        0x00,
        nh3HResiter[2],
        0x00,
        nh3HResiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = sendDeviceId);
    return (box);
  }

  Future<RtuMessage> sendNo2() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    deviceSubmitted();
    await stub.exClientstream(box
      ..gwId = ga1
      ..dataUnit = [
        no2Resiter[0],
        no2Resiter[1],
        0x00,
        no2Resiter[2],
        0x00,
        no2Resiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = sendDeviceId);
    return (box);
  }

  Future<RtuMessage> sendNo2L() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    deviceSubmitted();
    await stub.exClientstream(box
      ..gwId = ga1
      ..dataUnit = [
        no2LResiter[0],
        no2LResiter[1],
        0x00,
        no2LResiter[2],
        0x00,
        no2LResiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = sendDeviceId);
    return (box);
  }

  Future<RtuMessage> sendNo2M() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    deviceSubmitted();
    await stub.exClientstream(box
      ..gwId = ga1
      ..dataUnit = [
        no2MResiter[0],
        no2MResiter[1],
        0x00,
        no2MResiter[2],
        0x00,
        no2MResiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = sendDeviceId);
    return (box);
  }

  Future<RtuMessage> sendNo2H() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    deviceSubmitted();
    await stub.exClientstream(box
      ..gwId = ga1
      ..dataUnit = [
        no2HResiter[0],
        no2HResiter[1],
        0x00,
        no2HResiter[2],
        0x00,
        no2HResiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = sendDeviceId);
    return (box);
  }

  Future<RtuMessage> sendCo() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    deviceSubmitted();
    await stub.exClientstream(box
      ..gwId = ga1
      ..dataUnit = [
        coResiter[0],
        coResiter[1],
        0x00,
        coResiter[2],
        0x00,
        coResiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = sendDeviceId);
    return (box);
  }

  Future<RtuMessage> sendCoL() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    deviceSubmitted();
    await stub.exClientstream(box
      ..gwId = ga1
      ..dataUnit = [
        coLResiter[0],
        coLResiter[1],
        0x00,
        coLResiter[2],
        0x00,
        coLResiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = sendDeviceId);
    return (box);
  }

  Future<RtuMessage> sendCoM() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    deviceSubmitted();
    await stub.exClientstream(box
      ..gwId = ga1
      ..dataUnit = [
        coMResiter[0],
        coMResiter[1],
        0x00,
        coMResiter[2],
        0x00,
        coMResiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = sendDeviceId);
    return (box);
  }

  Future<RtuMessage> sendCoH() async {
    stub = ExProtoClient(ClientChannel(fireStoreIp,
        port: 5054,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure())));
    deviceSubmitted();
    await stub.exClientstream(box
      ..gwId = ga1
      ..dataUnit = [
        coHResiter[0],
        coHResiter[1],
        0x00,
        coHResiter[2],
        0x00,
        coHResiter[3],
        0xAD,
        0xDE
      ]
      ..deviceId = sendDeviceId);
    return (box);
  }
}

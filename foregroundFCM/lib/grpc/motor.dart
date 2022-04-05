import 'package:fcm_notifications/network.pbgrpc.dart';
import 'package:grpc/grpc.dart';

import '../data/data.dart';
import 'grpc.dart';

ExProtoClient stub;
final box = new RtuMessage();
var grpc = Grpc();

class MotorControl {
  Future<RtuMessage> motorReset() async {
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
        0xF5,
        0x00,
        0x02,
        0x04,
        0x00,
        0x01,
        opId >> 8,
        opId,
        0xAD,
        0xDE
      ]
      ..deviceId = motorDevice1);
    opId++;
    return (box);
  }

  Future<RtuMessage> motorStop() async {
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
        ..deviceId = motorDevice1);
      opId++;
    } catch (e) {
      print("error");
    }
    return (box);
  }

  Future<RtuMessage> motorLeft() async {
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
        ..deviceId = motorDevice1);
      opId++;
    } catch (e) {
      print("error");
    }
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
      ..deviceId = motorDevice1);
    opId++;
    return (box);
  }

  Future<RtuMessage> motorRightTimer() async {
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
        0x30,
        opId >> 8,
        opId,
        0x00, //0x00 >> 8
        0x00, // 구동 시간
        0x00,
        0x00,
        0xAD,
        0xDE
      ]
      ..deviceId = motorDevice1);
    opId++;
    return (box);
  }

  Future<RtuMessage> motorLeftTimer() async {
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
        0x2F,
        opId >> 8,
        opId,
        0x00, //0x00 >> 8
        0x00, // 구동 시간
        0x00,
        0x00,
        0xAD,
        0xDE
      ]
      ..deviceId = motorDevice1);
    opId++;
    return (box);
  }
}

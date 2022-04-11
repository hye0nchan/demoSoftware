import 'package:fcm_notifications/network.pbgrpc.dart';
import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';

import '../data/data.dart';
import 'grpc.dart';

final box = new RtuMessage();
var grpc = Grpc();
var protocol = 200;

var device;

ExProtoClient stub = ExProtoClient(ClientChannel(fireStoreIp,
    port: 5044,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure())));

class SwitchControl {
  Future<RtuMessage> switchReset(String switchName) async {
    switchDevice(switchName);

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
      ..deviceId = device);
    opId++;
    return (box);
  }

  Future<RtuMessage> switchFirstOn(String switchName) async {
    switchDevice(switchName);

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
        0xC9,
        opId >> 8,
        opId,
        0x00,
        0x00,
        0x00,
        0x00,
        0xAD,
        0xDE
      ]
      ..deviceId = device);
    opId++;
    return (box);
  }

  Future<RtuMessage> switchSecondOn(String switchName) async {
    switchDevice(switchName);

    await stub.exClientstream(box
      ..channel = protocol
      ..sequenceNumber = 0
      ..gwId = 0
      ..dataUnit = [
        0x01,
        0x10,
        0x01,
        0xFb,
        0x00,
        0x04,
        0x08,
        0x00,
        0xC9,
        opId >> 8,
        opId,
        0x00,
        0x00,
        0x00,
        0x00,
        0xAD,
        0xDE
      ]
      ..deviceId = device);
    opId++;
    return (box);
  }

  Future<RtuMessage> switchFirstOff(String switchName) async {
    switchDevice(switchName);

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
      ..deviceId = device);
    opId++;
    return (box);
  }

  Future<RtuMessage> switchSecondOff(String switchName) async {
    switchDevice(switchName);

    await stub.exClientstream(box
      ..channel = protocol
      ..sequenceNumber = 0
      ..gwId = 0
      ..dataUnit = [
        0x01,
        0x10,
        0x01,
        0xFb,
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
      ..deviceId = device);
    opId++;
    return (box);
  }

  void switchDevice(String switchName) {
    switch (switchName) {
      case "펌프":
        device = Int64.parseInt(int.parse(("0x" + "500291A40A61")).toString());
        break;
      case "팬":
        device = Int64.parseInt(int.parse(("0x" + "4C7525C1Cf81")).toString());
        break;
      case "램프":
        device = Int64.parseInt(int.parse(("0x" + "4C7525C1Cf81")).toString());
        break;
      case "환풍기":
        device = Int64.parseInt(int.parse(("0x" + "4C7525C1CF71")).toString());
        break;
    }
  }
}

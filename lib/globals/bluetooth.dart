import 'dart:async';

import 'package:bluez/bluez.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../utils/streams.dart';

const miniGroService = '0a7da35c-176e-4926-8999-5358c0a3704e';

abstract class Bluetooth {
  Future<void> startScan({
    Duration? timeout,
    bool all,
  });

  Future<void> stopScan();

  Future<void> connect(String address);

  Future<void> disconnect();
}

class BluePlus implements Bluetooth {
  @override
  Future<void> startScan({
    Duration? timeout,
    bool all = false,
  }) {
    final selectedServices = all ? const <Guid>[] : [Guid(miniGroService)];
    return FlutterBluePlus.startScan(
      timeout: timeout,
      withServices: selectedServices,
    );
  }

  @override
  Future<void> connect(String address) {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future<void> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<void> stopScan() {
    // TODO: implement stopScan
    throw UnimplementedError();
  }
}

class Bluez implements Bluetooth {
  final BlueZClient _ble;
  final scanStream = StreamControllerReEmit<List<ScanResult>>(initialValue: []);

  Bluez({required BlueZClient bluez}) : _ble = bluez;

  @override
  Future<void> startScan({
    Duration? timeout,
    bool all = false,
  }) {
    if (_ble.adapters.isEmpty) return Future.error('No bluetooth adapters');
    return _ble.adapters.first.startDiscovery();
  }

  @override
  Future<void> connect(String address) {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future<void> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<void> stopScan() {
    // TODO: implement stopScan
    throw UnimplementedError();
  }
}

import 'service.dart';

class BleAdapterData {
  final String name;
  final String? alias;

  final String address;

  BleAdapterData({required this.name, this.alias, required this.address});
}

abstract class DiscoveredDevice {
  Future<void> connect();

  Future<void> disconnect();

  bool get isConnected;

  String get id;

  String get name;

  int get rssi;

  Future<List<BleService>> get services;
}

abstract class BleAdapter {
  Future<void> startScan({
    bool all = false,
  });

  Future<void> stopScan();

  Future<bool> isScanningNow();

  bool get isScanning;

  BleAdapterData get info;

  Stream<List<DiscoveredDevice>> get scanResults;
}

import 'package:freezed_annotation/freezed_annotation.dart';

import 'service.dart';

part 'adapter.freezed.dart';

class BleAdapterData {
  final String name;
  final String? alias;

  final String address;

  BleAdapterData({required this.name, this.alias, required this.address});
}

@freezed
class BleAdapterInfo with _$BleAdapterInfo {
  const factory BleAdapterInfo({
    required String name,
    @Default('unknown') String address,
    @Default('default') String? alias,
  }) = _BleAdapterInfo;
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

  bool get isActive;

  BleAdapterInfo get info;

  Stream<List<DiscoveredDevice>> get scanResults;
}

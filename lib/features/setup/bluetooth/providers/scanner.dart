import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:minigro/features/setup/bluetooth/providers/adapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/adapter.dart';

part 'scanner.g.dart';

@riverpod
Future<List<BluetoothDevice>> systemDevices(SystemDevicesRef ref) {
  return Platform.isLinux ? Future.value([]) : FlutterBluePlus.systemDevices;
}

@riverpod
Stream<List<DiscoveredDevice>> scanResults(ScanResultsRef ref) {
  final adapter = ref.watch(adapterProvider);
  switch (adapter) {
    case AsyncData(value: final phy):
      if (!phy.isScanning) {
        phy.startScan();
      }
      return phy.scanResults;
    default:
      return Stream.value(<DiscoveredDevice>[]);
  }
}

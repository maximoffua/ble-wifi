import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:minigro/globals/getit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/adapter.dart';
import 'adapter.dart';

part 'scanner.g.dart';

@riverpod
Future<List<BluetoothDevice>> systemDevices(SystemDevicesRef ref) {
  return Platform.isLinux ? Future.value([]) : FlutterBluePlus.systemDevices;
}

@riverpod
Stream<List<DiscoveredDevice>> scanResults(ScanResultsRef ref) {
  final adapter = ref.watch(adapterProvider);
  switch (adapter) {
    case AsyncData(value: final adapter):
      if (!adapter.isScanning) {
        log.debug("Starting BLE scan");
        adapter.startScan().catchError((e) {
          log.error("Failed to start scanning", e);
        });
      }
      return adapter.scanResults;
    case AsyncError(:final error):
      log.error("Cannot get BLE adapter", error);
    default:
  }
  return const Stream.empty();
}

@riverpod
Stream<bool> isScanning(IsScanningRef ref) {
  final adapter = ref.watch(adapterProvider);
  if (Platform.isLinux) {
    if (adapter case AsyncData(value: final adapter)) {
      return Stream.value(adapter.isScanning);
    }
    return const Stream.empty();
  }
  log.debug(">> isScanning: ${FlutterBluePlus.isScanning.last}");
  return FlutterBluePlus.isScanning;
}

@riverpod
Future<bool> isScanningNow(IsScanningNowRef ref) async {
  return FlutterBluePlus.isScanningNow;
}

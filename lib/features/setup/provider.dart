import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
Stream<List<ScanResult>> scanResults(ScanResultsRef ref) {
  return FlutterBluePlus.scanResults;
}

@riverpod
Stream<bool> scanning(ScanningRef ref) {
  return FlutterBluePlus.isScanning;
}

@riverpod
Stream<BluetoothAdapterState> adapterState(AdapterStateRef ref) {
  return FlutterBluePlus.adapterState;
}

@riverpod
Future<List<BluetoothDevice>> systemDevices(SystemDevicesRef ref) async {
  return FlutterBluePlus.systemDevices;
}

@riverpod
class BleService extends _$BleService {
  @override
  Future<void> build() async {
    // return;
  }
}

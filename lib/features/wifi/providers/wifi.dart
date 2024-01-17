import 'package:minigro/globals/getit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wifi_scan/wifi_scan.dart';

part 'wifi.g.dart';

@riverpod
class WifiScanning extends _$WifiScanning {
  @override
  Future<bool> build() async {
    final can =
        await getIt<WiFiScan>().canGetScannedResults(askPermissions: true);
    switch (can) {
      case CanGetScannedResults.notSupported:
        throw "WiFi scan is not supported";
      case CanGetScannedResults.noLocationPermissionRequired:
        throw "need location permission";
      case CanGetScannedResults.noLocationPermissionDenied:
        throw "location permission denied";
      case CanGetScannedResults.noLocationPermissionUpgradeAccuracy:
        throw "location permission upgrade accuracy";
      case CanGetScannedResults.noLocationServiceDisabled:
        throw "location service disabled";
      case CanGetScannedResults.yes:
        return await _startScan();
    }
  }

  Future<bool> _startScan() async {
    final can = await getIt<WiFiScan>().canStartScan(askPermissions: true);
    switch (can) {
      case CanStartScan.notSupported:
        throw "WiFi scan is not supported";
      case CanStartScan.noLocationPermissionRequired:
        throw "need location permission";
      case CanStartScan.noLocationPermissionDenied:
        throw "location permission denied";
      case CanStartScan.noLocationPermissionUpgradeAccuracy:
        throw "location permission upgrade accuracy";
      case CanStartScan.noLocationServiceDisabled:
        throw "location service disabled";
      case CanStartScan.failed:
        throw "wifi scan failed";
      case CanStartScan.yes:
        return await WiFiScan.instance.startScan();
    }
  }

  void startScan() async {
    state = await AsyncValue.guard(() => _startScan());
  }
}

@riverpod
Future<List<WiFiAccessPoint>> networkList(NetworkListRef ref) async {
  final can =
      await getIt<WiFiScan>().canGetScannedResults(askPermissions: false);
  switch (can) {
    case CanGetScannedResults.yes:
      return await WiFiScan.instance.getScannedResults();
    case CanGetScannedResults.notSupported:
      throw "WiFi scan is not supported";
    case CanGetScannedResults.noLocationPermissionRequired:
      throw "need location permission";
    case CanGetScannedResults.noLocationPermissionDenied:
      throw "location permission denied";
    case CanGetScannedResults.noLocationPermissionUpgradeAccuracy:
      throw "location permission upgrade accuracy";
    case CanGetScannedResults.noLocationServiceDisabled:
      throw "location service disabled";
  }
}

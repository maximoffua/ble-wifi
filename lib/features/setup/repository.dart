import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository.g.dart';

@riverpod
class BleAdapter extends _$BleAdapter {
  @override
  Stream<BluetoothAdapterState> build() {
    return FlutterBluePlus.adapterState;
  }

  void startScan({
    List<Guid> withServices = const [],
    List<String> withKeywords = const [],
    List<MsdFilter> withMsd = const [],
    Duration? timeout,
    AndroidScanMode androidScanMode = AndroidScanMode.lowLatency,
    bool androidUsesFineLocation = true,
  }) async {
    await FlutterBluePlus.startScan(
      withServices: withServices,
      withKeywords: withKeywords,
      withMsd: withMsd,
      timeout: timeout,
      androidScanMode: androidScanMode,
      androidUsesFineLocation: androidUsesFineLocation,
    );
  }

  void stopScan() async {
    await FlutterBluePlus.stopScan();
  }
}

// @riverpod
// class BleScanRepository extends _$BleScanRepository {
//   // listen to scan results
// // Note: `onScanResults` only returns live scan results, i.e. during scanning
// // Use: `scanResults` if you want live scan results *or* the previous results
//   var subscription = FlutterBluePlus.onScanResults.listen((results) {
//     if (results.isNotEmpty) {
//       ScanResult r = results.last; // the most recently found device
//       print('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
//     }
//   },
//       onError(e) => print(e);
//   );
//
// // Wait for Bluetooth enabled & permission granted
// // In your real app you should use `FlutterBluePlus.adapterState.listen` to handle all states
//   await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;
//
// // Start scanning
//   await FlutterBluePlus.startScan();
//
// // Stop scanning
//   await FlutterBluePlus.stopScan();
//
// // cancel to prevent duplicate listeners
//   subscription.cancel();
//
//   @override
//   FutureOr<bool> build() async {
//     return true;
//   }
//
//   // scan BLE devices with flutter_blue_plus
//   @override
//   FutureOr<List<BleDevice>> startScan() async {
//     try {
//       _systemDevices = await FlutterBluePlus.systemDevices;
//     } catch (e) {
//       Snackbar.show(ABC.b, prettyException("System Devices Error:", e),
//           success: false);
//     }
//
//     try {
//       // android is slow when asking for all advertisments,
//       // so instead we only ask for 1/8 of them
//       int divisor = Platform.isAndroid ? 8 : 1;
//       await FlutterBluePlus.startScan(
//           timeout: const Duration(seconds: 15),
//           continuousUpdates: true,
//           continuousDivisor: divisor);
//     } catch (e) {
//       Snackbar.show(ABC.b, prettyException("Start Scan Error:", e),
//           success: false);
//     }
//     setState(() {});
//   }
//
//   @override
//   FutureOr<bool> connect(BleDevice bleDevice) async {
//     return await FlutterBluePlus.connect(bleDevice);
//   }
// }

class MiniGroBleGatt {
  static const wifiSsid = '1a7da35c-176e-4926-8999-5358c0a3704e';
  static const wifiPassword = '2a7da35c-176e-4926-8999-5358c0a3704e';
  static const deviceID = '3a7da35c-176e-4926-8999-5358c0a3704e';
  static const mainButton = '1c7da35c-176e-4926-8999-5358c0a3704e';
  static const auxButton1 = '2c7da35c-176e-4926-8999-5358c0a3704e';
  static const auxButton2 = '3c7da35c-176e-4926-8999-5358c0a3704e';
  static const reedButton1 = '4c7da35c-176e-4926-8999-5358c0a3704e';
  static const reedButton2 = '5c7da35c-176e-4926-8999-5358c0a3704e';
  static const reedButton3 = '6c7da35c-176e-4926-8999-5358c0a3704e';
  static const waterLevel = '7c7da35c-176e-4926-8999-5358c0a3704e';
  static const waterTemp = '1b7da35c-176e-4926-8999-5358c0a3704e';
  static const temp = '2b7da35c-176e-4926-8999-5358c0a3704e';
  static const humidity = '3b7da35c-176e-4926-8999-5358c0a3704e';
  static const light = '4b7da35c-176e-4926-8999-5358c0a3704e';
  static const ph = '5b7da35c-176e-4926-8999-5358c0a3704e';
  static const conductivity = '6b7da35c-176e-4926-8999-5358c0a3704e';

  static const id = '0a7da35c-176e-4926-8999-5358c0a3704e';
}

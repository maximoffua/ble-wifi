import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ble_service.g.dart';

@riverpod
class BleAdapter extends _$BleAdapter {
  @override
  Stream<BluetoothAdapterState> build() {
    return FlutterBluePlus.adapterState;
  }

  Future<void> startScan({
    List<Guid> withServices = const [],
    List<String> withKeywords = const [],
    List<MsdFilter> withMsd = const [],
    Duration? timeout,
    AndroidScanMode androidScanMode = AndroidScanMode.lowLatency,
    bool androidUsesFineLocation = true,
    int continuousDivisor = 0,
  }) async {
    await FlutterBluePlus.startScan(
      withServices: withServices,
      withKeywords: withKeywords,
      withMsd: withMsd,
      timeout: timeout,
      androidScanMode: androidScanMode,
      androidUsesFineLocation: androidUsesFineLocation,
      continuousDivisor: continuousDivisor > 0 ? continuousDivisor : 1,
      continuousUpdates: continuousDivisor > 0,
    );
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }
}

final miniGroServiceId = Guid("0A7DA35C176E492689995358C0A3704E");
final ssidChr = Guid("1A7DA35C176E492689995358C0A3704E");
final passChr = Guid("2A7DA35C176E492689995358C0A3704E");

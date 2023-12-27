import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:minigro/features/setup/bluetooth/models/service.dart';
import 'package:minigro/globals/bluetooth.dart';

import '../extensions.dart';
import 'adapter.dart';

class MobileAdapter implements BleAdapter {
  MobileAdapter({required this.name});

  static Future<MobileAdapter> create() async =>
      MobileAdapter(name: await FlutterBluePlus.adapterName);

  final String name;

  @override
  bool get isScanning => FlutterBluePlus.isScanningNow;

  @override
  Future<bool> isScanningNow() => FlutterBluePlus.isScanning.first;

  @override
  Stream<List<DiscoveredDevice>> get scanResults => FlutterBluePlus.scanResults
      .map((event) => BleDeviceMobile.fromList(event));

  @override
  Future<void> startScan({bool all = false}) async {
    final selectedServices = all ? <Guid>[] : [Guid(miniGroService)];
    return FlutterBluePlus.startScan(withServices: selectedServices);
  }

  @override
  Future<void> stopScan() => FlutterBluePlus.stopScan();

  @override
  BleAdapterData get info =>
      BleAdapterData(name: name, address: 'unknown', alias: 'default');
}

class BleDeviceMobile extends DiscoveredDevice {
  final BluetoothDevice _d;
  final AdvertisementData _adv;

  @override
  final int rssi;

  BleDeviceMobile(this._d, this._adv, this.rssi);

  static List<BleDeviceMobile> fromList(
          List<ScanResult> scanResults) =>
      scanResults
          .map((event) => BleDeviceMobile(
              event.device, event.advertisementData, event.rssi))
          .toList();

  @override
  Future<void> connect() => _d.connect();

  @override
  Future<void> disconnect() => _d.disconnect();

  @override
  String get id => _d.remoteId.str;

  @override
  bool get isConnected => _d.isConnected;

  @override
  Future<List<BleService>> get services =>
      Future.value(BleServiceMobile.fromList(_d.servicesList));

  @override
  String get name => _d.platformName;
}

class BleServiceMobile implements BleService {
  final BluetoothService _s;

  BleServiceMobile(this._s);

  @override
  // TODO: implement characteristics
  Future<List<GattCharacteristic>> get characteristics =>
      Future.value(GattCharacteristicMobile.fromList(_s.characteristics));

  @override
  // TODO: implement includedServices
  Future<List<BleService>> get includedServices =>
      Future.value(BleServiceMobile.fromList(_s.includedServices));

  static List<BleServiceMobile> fromList(List<BluetoothService> services) =>
      services.map((service) => BleServiceMobile(service)).toList();

  @override
  DeviceIdentifier get deviceId => _s.remoteId;

  @override
  Guid get id => _s.uuid;

  @override
  bool get isPrimary => _s.isPrimary;
}

class GattCharacteristicMobile implements GattCharacteristic {
  final BluetoothCharacteristic _c;

  GattCharacteristicMobile(this._c);

  @override
  Guid get id => _c.uuid;

  @override
  Future<Stream<String>> notifications() {
    return Future.value(_c.onValueReceived.map((event) => event.asString()));
  }

  @override
  Future<String> read() => _c.read().then((value) => value.asString());

  @override
  DeviceIdentifier get remoteId => _c.remoteId;

  @override
  Guid? get secondaryServiceId => _c.secondaryServiceUuid;

  @override
  Guid get serviceId => _c.serviceUuid;

  @override
  Future<void> write(String data) => _c.write(data.codeUnits);

  static List<GattCharacteristicMobile> fromList(
          List<BluetoothCharacteristic> characteristics) =>
      characteristics
          .map((characteristic) => GattCharacteristicMobile(characteristic))
          .toList();
}

import 'package:bluez/bluez.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hive/hive.dart';
import 'package:minigro/features/setup/bluetooth/models/service.dart';
import 'package:minigro/globals/bluetooth.dart';
import 'package:minigro/globals/getit.dart';
import 'package:minigro/utils/streams.dart';
import 'package:talker/talker.dart';

import 'adapter.dart';

class LinuxAdapter implements BleAdapter {
  final BlueZAdapter _a;
  final scanStream =
      StreamControllerReEmit<List<DiscoveredDevice>>(initialValue: []);

  LinuxAdapter(this._a);

  factory LinuxAdapter.restore(BlueZClient client) {
    final settings = Hive.box<String>(name: 'settings');
    final set = settings.get('bluetooth_adapter');
    final adapter = client.adapters.firstWhere(
        (a) => a.name == set || a.alias == set,
        orElse: () => client.adapters.first);
    return LinuxAdapter(adapter);
  }

  store() {
    final settings = Hive.box<String>(name: 'settings');
    settings.put('bluetooth_adapter', _a.name);
  }

  @override
  Future<void> startScan({
    bool all = false,
  }) async {
    if (!all) {
      await _a.setDiscoveryFilter(uuids: [miniGroService]);
    }
    return await _a.startDiscovery();
  }

  @override
  Future<void> stopScan() {
    return _a.stopDiscovery();
  }

  @override
  Future<bool> isScanningNow() async {
    return Future.value(_a.discovering);
  }

  @override
  bool get isScanning => _a.discovering;

  @override
  Stream<List<DiscoveredDevice>> get scanResults => scanStream.stream;

  @override
  BleAdapterData get info =>
      BleAdapterData(name: _a.name, address: _a.address, alias: _a.alias);
}

class BluezDevice implements DiscoveredDevice {
  final BlueZDevice _d;

  BluezDevice(this._d);

  @override
  Future<void> connect() {
    return _d.connect();
  }

  @override
  Future<void> disconnect() {
    return _d.disconnect();
  }

  @override
  String get id => _d.address;

  @override
  bool get isConnected => _d.connected;

  @override
  Future<List<BleService>> get services =>
      Future.value(_d.gattServices.map((e) => BluezService(_d, e)).toList());

  @override
  String get name => _d.alias.isEmpty ? _d.name : _d.alias;

  @override
  int get rssi => _d.rssi;
}

class BluezService implements BleService {
  final BlueZDevice _d;
  final BlueZGattService _s;

  BluezService(this._d, this._s);

  @override
  Future<List<GattCharacteristic>> get characteristics => Future.value(
      _s.characteristics.map((e) => BluezCharacteristic(this, e)).toList());

  @override
  DeviceIdentifier get deviceId => DeviceIdentifier(_d.address);

  @override
  Guid get id => Guid(_s.uuid.toString());

  @override
  Future<List<BleService>> get includedServices => Future.value([]);

  @override
  bool get isPrimary => _s.primary;
}

class BluezCharacteristic implements GattCharacteristic {
  final BluezService _s;
  final BlueZGattCharacteristic _c;

  BluezCharacteristic(
    this._s,
    this._c,
  );

  @override
  Guid get id => Guid(_c.uuid.toString());

  Future<void> _acquireNotify() async {
    final q = await _c.acquireNotify();
    final Talker talker = getIt();
    q.socket.listen((event) {
      talker.debug("""Event from notification channel.
      
      ${event.toString()}
      
      type: ${event.runtimeType.toString()}""");
    });
  }

  @override
  Future<Stream<String>> notifications() async {
    await _acquireNotify();
    return Stream.value("");
  }

  @override
  Future<String> read() async {
    return String.fromCharCodes(await _c.readValue(offset: 0));
  }

  @override
  DeviceIdentifier get remoteId => _s.deviceId;

  @override
  Future<void> write(String data) {
    return _c.writeValue(data.codeUnits);
  }

  @override
  // TODO: implement secondaryServiceId
  Guid? get secondaryServiceId => throw UnimplementedError();

  @override
  // TODO: implement serviceId
  Guid get serviceId => throw UnimplementedError();
}

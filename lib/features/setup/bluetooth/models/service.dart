import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:minigro/globals/bluetooth.dart';

final miniGroServiceId = Guid("0A7DA35C176E492689995358C0A3704E");
final ssidChr = Guid("1A7DA35C176E492689995358C0A3704E");
final passChr = Guid("2A7DA35C176E492689995358C0A3704E");

abstract class BleService {
  final DeviceIdentifier deviceId;
  final Guid id;
  final bool isPrimary;

  BleService(
      {required this.deviceId, required this.id, required this.isPrimary});

  Future<List<GattCharacteristic>> get characteristics;

  Future<List<BleService>> get includedServices;
}

abstract class GattCharacteristic {
  final DeviceIdentifier remoteId;
  final Guid serviceId;
  final Guid? secondaryServiceId;
  final Guid id;

  GattCharacteristic(
      {required this.remoteId,
      required this.serviceId,
      required this.secondaryServiceId,
      required this.id});

  Future<void> write(String data);

  Future<String> read();

  Future<Stream<String>> notifications();
}

class MiniGroService {
  static final uuid = Guid(miniGroService);
  static final ssid = Guid("1A7DA35C176E492689995358C0A3704E");
  static final password = Guid("2A7DA35C176E492689995358C0A3704E");
}

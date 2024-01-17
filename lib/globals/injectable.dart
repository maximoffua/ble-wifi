import 'dart:io';

import 'package:bluez/bluez.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../features/setup/bluetooth/models/adapter.dart';
import '../features/setup/bluetooth/models/adapter_linux.dart';
import '../features/setup/bluetooth/models/adapter_mobile.dart';
import 'getit.dart';
import 'injectable.config.dart';

@InjectableInit(
  preferRelativeImports: true,
  generateForDir: ['lib'],
)
Future configureDependencies() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;

  return sl.init();
}

@module
abstract class AppModule {
  @lazySingleton
  Talker get talker => TalkerFlutter.init();

  @singleton
  @Order(-1)
  Future<Hive> hive() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.defaultDirectory = dir.path;
    return Hive();
  }

  Box<String> settings() => Hive.box<String>(name: 'settings');
}

@module
abstract class BluetoothModule {
  @lazySingleton
  Future<BlueZClient> bluez() async {
    final client = BlueZClient();
    await client.connect();
    return client;
  }

  // @Order(100)
  @lazySingleton
  Future<BleAdapter> get bleAdapter async {
    final res = Platform.isLinux
        ? LinuxAdapter.restore(await getItA())
        : await MobileAdapter.create();
    getIt<Talker>().debug("get ble adapter ${res.runtimeType}");
    return res;
  }

  @lazySingleton
  WiFiScan get wifi => WiFiScan.instance;
}

import 'dart:io';

import 'package:bluez/bluez.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:minigro/globals/getit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/adapter.dart';
import '../models/adapter_linux.dart';

part 'adapter.g.dart';

@riverpod
class Adapter extends _$Adapter {
  @override
  Future<BleAdapter> build() => getItA();

  Future startScan({bool all = false}) async {
    if (state case AsyncData(value: final adapter)) {
      await adapter.startScan(all: all);
    }
  }

  Future stopScan() async {
    if (state case AsyncData(value: final adapter)) {
      await adapter.stopScan();
    }
  }

  changeAdapter(BleAdapterInfo? item) async {
    stopScan();
    if (item == null || !Platform.isLinux) {
      return;
    }
    final client = await getItA<BlueZClient>();
    final adapter = client.adapters.firstWhere(
        (a) => a.name == item.name || a.alias == item.name,
        orElse: () => client.adapters.first);
    state = AsyncData(LinuxAdapter(adapter)..store());
  }
}

@riverpod
Future<List<BleAdapterInfo>> availableAdapters(AvailableAdaptersRef ref) async {
  return Platform.isLinux
      ? (await getItA<BlueZClient>())
          .adapters
          .map((a) =>
              BleAdapterInfo(name: a.name, address: a.address, alias: a.alias))
          .toList()
      : [BleAdapterInfo(name: await FlutterBluePlus.adapterName)];
}

@Riverpod(keepAlive: false)
Stream<BluetoothAdapterState> adapterState(AdapterStateRef ref) {
  final adapter = ref.watch(adapterProvider);
  if (Platform.isLinux) {
    return Stream.value((adapter.value?.isActive ?? false)
        ? BluetoothAdapterState.on
        : BluetoothAdapterState.off);
  }
  return FlutterBluePlus.adapterState;
}

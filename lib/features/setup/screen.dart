import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sandbox/features/setup/provider.dart';
import 'package:sandbox/router/root.dart';
import 'package:sandbox/services/global.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'screens/scan_screen.dart';

export 'screens/bluetooth_off_screen.dart';
export 'screens/device_screen.dart';
export 'screens/scan_screen.dart';

@RoutePage()
class BleScreen extends ConsumerWidget {
  final Talker talker = getIt();

  BleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adapterStateProvider);
    if (state case AsyncError(error: final e, stackTrace: final st)) {
      talker.error("cannot get Bluetooth state", e, st);
    }
    if (state.value != null && state.value != BluetoothAdapterState.on) {
      context.pushRoute(BluetoothOffRoute(adapterState: state.value));
    }

    switch (state) {
      case AsyncError(error: final e, stackTrace: final st):
        talker.error("cannot get Bluetooth state", e, st);
      case AsyncLoading():
        return const Placeholder();
      default:
    }

    return const ScanScreen();
    // return GrovScaffold(
    //   body: switch (results) {
    //     AsyncData(:final value) => ListView.builder(
    //         itemCount: value.length,
    //         itemBuilder: (context, index) => ListTile(
    //           title: Text(_resultTitle(value[index])),
    //           subtitle: Text(value[index]
    //               .advertisementData
    //               .serviceUuids
    //               .length
    //               .toString()),
    //         ),
    //       ),
    //     AsyncError(:final error) => Center(child: Text(error.toString())),
    //     _ => null,
    //   },
    // );
  }

  String _resultTitle(ScanResult result) =>
      "${result.advertisementData.advName} [${result.advertisementData.manufacturerData.toString()}] - ${result.rssi.toString()}";
}

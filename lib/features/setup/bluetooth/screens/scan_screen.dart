import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minigro/features/setup/bluetooth/providers/adapter.dart';
import 'package:minigro/routes/root.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../../globals/getit.dart';
import '../extensions.dart';
import '../providers/scanner.dart';
import 'widgets/scan_result_tile.dart';
import 'widgets/system_device_tile.dart';

// @RoutePage()
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final Talker talker = getIt();

  @override
  void initState() {
    super.initState();
    ref
        .read(adapterProvider.notifier)
        .startScan()
        .catchError((e) => talker.error("Failed to start scanning", e));
  }

  Future onScanPressed() async {
    final systemDevices = ref.watch(systemDevicesProvider);
    if (systemDevices.hasError) {
      talker.error("Cannot get system devices", systemDevices.error!,
          systemDevices.stackTrace);
    }

    try {
      await ref.read(adapterProvider.notifier).startScan();
    } catch (e, st) {
      talker.error("Start BLE scan failed", e, st);
    }
  }

  Future onStopPressed() async {
    try {
      await ref.read(adapterProvider.notifier).stopScan();
    } catch (e, st) {
      talker.error("Stop BLE scan failed", e, st);
    }
  }

  void onConnectPressed(BluetoothDevice device) {
    device.connectAndUpdateStream().catchError((e) {
      talker.error("Failed to connect to device", e);
    });
    context.pushRoute(DeviceRoute(device: device));
  }

  Future onRefresh() {
    final adapter = ref.read(adapterProvider).valueOrNull;
    if (adapter != null && !adapter.isScanning) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 25));
    }
    return Future.delayed(const Duration(milliseconds: 500));
  }

  Widget buildScanButton(BuildContext context) {
    if (FlutterBluePlus.isScanningNow) {
      return FloatingActionButton(
        onPressed: onStopPressed,
        backgroundColor: Colors.red,
        child: const Icon(Icons.stop),
      );
    } else {
      return FloatingActionButton(
          onPressed: onScanPressed, child: const Text("SCAN"));
    }
  }

  List<Widget> _buildSystemDeviceTiles(BuildContext context) {
    final systemDevices = ref.watch(systemDevicesProvider);
    if (systemDevices case AsyncError(error: final e, stackTrace: final st)) {
      talker.error("Cannot get system devices", e, st);
    }
    return systemDevices.value
            ?.map(
              (d) => SystemDeviceTile(
                device: d,
                onOpen: () => context.pushRoute(DeviceRoute(device: d)),
                onConnect: () => onConnectPressed(d),
              ),
            )
            .toList() ??
        [];
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    final results = ref.watch(scanResultsProvider);
    if (results.hasError) {
      // talker.handle(results.error!, results.stackTrace, 'Scan error');
      talker.error("Scan error", results.error!, results.stackTrace);
      // Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    }
    return switch (results) {
      AsyncData(:final value) => value
          .map((r) => ScanResultTile(
                result: r,
                onTap: () => context.pushRoute(NetworksRoute(device: r)),
              ))
          .toList(),
      _ => [],
    };
  }

  @override
  Widget build(BuildContext context) {
    return TalkerWrapper(
      talker: talker,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Find micro farms'),
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            children: <Widget>[
              ..._buildSystemDeviceTiles(context),
              ..._buildScanResultTiles(context),
            ],
          ),
        ),
        floatingActionButton: buildScanButton(context),
      ),
    );
  }
}

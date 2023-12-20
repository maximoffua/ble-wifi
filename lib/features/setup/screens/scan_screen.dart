import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sandbox/features/setup/ble_service.dart';
import 'package:sandbox/router/root.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../services/global.dart';
import '../provider.dart';
import '../utils/extra.dart';
import '../utils/snackbar.dart';
import '../widgets/scan_result_tile.dart';
import '../widgets/system_device_tile.dart';

@RoutePage()
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
    ref.read(bleAdapterProvider.notifier).startScan(
      timeout: const Duration(seconds: 45),
      // withMsd: [MsdFilter(0x4752)],
      withServices: [miniGroServiceId],
      // continuousDivisor: divisor,
    ).catchError((e) => talker.error("Failed to start scanning", e));
  }

  Future onScanPressed() async {
    final systemDevices = ref.watch(systemDevicesProvider);
    if (systemDevices.hasError) {
      talker.error("Cannot get system devices", systemDevices.error!,
          systemDevices.stackTrace);
    }

    try {
      // android is slow when asking for all advertisements,
      // so instead we only ask for 1/8 of them
      int divisor = Platform.isAndroid ? 8 : 1;
      await ref.read(bleAdapterProvider.notifier).startScan(
        timeout: const Duration(seconds: 45),
        withMsd: [MsdFilter(0x4752)],
        withServices: [miniGroServiceId],
        // continuousDivisor: divisor,
      );
    } catch (e, st) {
      talker.error("Start BLE scan failed", e, st);
    }
  }

  Future onStopPressed() async {
    try {
      await ref.read(bleAdapterProvider.notifier).stopScan();
    } catch (e, st) {
      talker.error("Stop BLE scan failed", e, st);
    }
  }

  void onConnectPressed(BluetoothDevice device) {
    device.connectAndUpdateStream().catchError((e) {
      Snackbar.show(ABC.c, prettyException("Connect Error:", e),
          success: false);
    });
    context.pushRoute(DeviceRoute(device: device));
  }

  Future onRefresh() {
    final isScanning = ref.read(scanningProvider);
    if (isScanning case AsyncError(:final error)) {
      talker.error("failed to get scanning status", error);
    }
    if (isScanning.value == false) {
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
                onTap: () => context.pushRoute(NetworksRoute(device: r.device)),
              ))
          .toList(),
      _ => [],
    };
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: Snackbar.snackBarKeyB,
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

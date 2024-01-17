import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minigro/features/setup/bluetooth/models/adapter.dart';
import 'package:minigro/features/setup/bluetooth/providers/adapter.dart';
import 'package:minigro/globals/getit.dart';
import 'package:minigro/routes/root.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../providers/scanner.dart';
import 'widgets/scan_result_tile.dart';

@RoutePage()
class DeviceListPage extends ConsumerStatefulWidget {
  const DeviceListPage({super.key});

  @override
  ConsumerState createState() => _DeviceListPageState();
}

class _DeviceListPageState extends ConsumerState<DeviceListPage> {
  @override
  Widget build(BuildContext context) {
    final adapter = ref.watch(adapterProvider);
    final aState = ref.watch(adapterStateProvider);
    switch (aState) {
      case AsyncData(value: final state):
        switch (state) {
          case BluetoothAdapterState.on || BluetoothAdapterState.turningOn:
            break;
          case BluetoothAdapterState.turningOff:
            break;
          case BluetoothAdapterState.off:
          case BluetoothAdapterState.unauthorized:
          case BluetoothAdapterState.unavailable:
            log.info("Navigate to Bluetooth off page: $state");
            context.navigateTo(BluetoothOffRoute(adapterState: state));
            break;
          default:
            log.warning("Unsupported state: $state");
        }
      case AsyncError(:final error):
        log.error("Failed to get BLE adapter state", error);
      default:
        break;
    }

    final results = ref.watch(scanResultsProvider);
    if (results.hasError) {
      log.error("Failed to get BLE devices nearby", results.error);
    }
    final router = AutoRouter.of(context);
    return TalkerWrapper(
      talker: getIt(),
      child: Scaffold(
        appBar: AppBar(title: SelectAdapter(selected: adapter.value?.info)),
        floatingActionButton: IconButton(
            icon: const Icon(Icons.wifi),
            onPressed: () => router.push(const WifiListRoute())),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: switch (results) {
            AsyncData(hasValue: true, :final value) => ListView(
                children: _buildScanResult(context, value),
              ),
            AsyncLoading() => const Center(child: CircularProgressIndicator()),
            AsyncError(:final error) => Center(child: Text(error.toString())),
            _ => const Center(child: Text('Unknown error')),
          },
        ),
      ),
    );
  }

  Future onRefresh() {
    final adapter = ref.watch(adapterProvider).value;
    if (adapter != null && !adapter.isScanning) {
      adapter.startScan();
    }
    return Future.delayed(const Duration(milliseconds: 500));
  }

  List<Widget> _buildScanResult(
      BuildContext context, List<DiscoveredDevice> results) {
    return results
        .map(
          (dev) => ScanResultTile(
            result: dev,
            onTap: () => context.navigateTo(NetworksRoute(device: dev)),
          ),
        )
        .toList();
  }
}

class SelectAdapter extends ConsumerWidget {
  final Widget? placeholder;
  final BleAdapterInfo? selected;
  final void Function(BleAdapterInfo?)? onChanged;

  const SelectAdapter({
    super.key,
    this.placeholder,
    this.selected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableAdapters = ref.watch(availableAdaptersProvider).value;
    getIt<Talker>().debug("Available adapters: $availableAdapters [$selected]");
    getIt<Talker>().debug(
        "Selected adapter: ${selected?.name} ${selected == availableAdapters?.first} ${availableAdapters?.first.name}");
    return availableAdapters != null && availableAdapters.isNotEmpty
        ? availableAdapters.length > 1
            ? DropdownMenu<BleAdapterInfo>(
                initialSelection: selected,
                onSelected: (item) =>
                    ref.read(adapterProvider.notifier).changeAdapter(item),
                dropdownMenuEntries: availableAdapters
                    .map((e) => DropdownMenuEntry(value: e, label: e.name))
                    .toList(),
              )
            : Text(availableAdapters.first.name)
        : placeholder ?? const Text('No adapters found');
  }
}

class ScanButton extends ConsumerWidget {
  final BleAdapter? adapter;

  const ScanButton({super.key, this.adapter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanning = ref.watch(isScanningProvider);
    log.debug("Scanning: $scanning");
    final isScanning = scanning.value ?? adapter?.isScanning ?? false;

    return FloatingActionButton(
      onPressed: () => isScanning
          ? ref.read(adapterProvider.notifier).stopScan()
          : ref.read(adapterProvider.notifier).startScan(all: true),
      child: isScanning ? const Icon(Icons.stop) : const Text("SCAN"),
    );
  }
}

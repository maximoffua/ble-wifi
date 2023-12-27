import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minigro/features/setup/bluetooth/models/adapter.dart';
import 'package:minigro/features/setup/bluetooth/providers/adapter.dart';
import 'package:minigro/globals/getit.dart';
import 'package:minigro/routes/root.dart';
import 'package:talker/talker.dart';

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
    final results = ref.watch(scanResultsProvider);
    if (results.hasError) {
      getIt<Talker>().error("Failed to get BLE devices nearby", results.error);
    }
    return Scaffold(
      appBar: AppBar(title: SelectAdapter(selected: adapter.value?.info)),
      floatingActionButton: ScanButton(adapter: adapter.value),
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
    );
  }

  Future onRefresh() {
    final adapter = ref.watch(adapterProvider).valueOrNull;
    if (adapter != null && !adapter.isScanning) {
      adapter.startScan(all: true);
    }
    return Future.delayed(const Duration(milliseconds: 500));
  }

  List<Widget> _buildScanResult(
      BuildContext context, List<DiscoveredDevice> results) {
    return results
        .map(
          (r) => ScanResultTile(
            result: r,
            onTap: () => context.pushRoute(NetworksRoute(device: r)),
          ),
        )
        .toList();
  }
}

class SelectAdapter extends ConsumerWidget {
  final Widget? placeholder;
  final BleAdapterData? selected;
  final void Function(BleAdapterData?)? onChanged;

  const SelectAdapter({
    super.key,
    this.placeholder,
    this.selected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableAdapters = ref.watch(availableAdaptersProvider).value;
    return availableAdapters != null && availableAdapters.isNotEmpty
        ? DropdownMenu<BleAdapterData>(
            initialSelection: selected,
            onSelected: (item) =>
                ref.read(adapterProvider.notifier).changeAdapter(item),
            dropdownMenuEntries: availableAdapters
                .map((e) => DropdownMenuEntry(value: e, label: e.name))
                .toList(),
          )
        : placeholder ?? const Text('No adapters found');
  }
}

class ScanButton extends ConsumerWidget {
  final BleAdapter? adapter;

  const ScanButton({super.key, this.adapter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (adapter == null) {
      return FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.grey,
        child: const Text("SCAN"),
      );
    }

    return FloatingActionButton(
      onPressed: () =>
          adapter!.isScanning ? adapter!.stopScan() : adapter!.startScan(),
      child: adapter!.isScanning ? const Icon(Icons.stop) : const Text("SCAN"),
    );
  }
}

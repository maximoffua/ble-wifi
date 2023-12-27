import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minigro/features/setup/bluetooth/models/adapter.dart';

class ScanResultTile extends ConsumerStatefulWidget {
  const ScanResultTile({super.key, required this.result, this.onTap});

  final DiscoveredDevice result;
  final VoidCallback? onTap;

  @override
  ConsumerState createState() => _ScanResultTileState();
}

class _ScanResultTileState extends ConsumerState<ScanResultTile> {
  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]';
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    return data.entries
        .map((entry) =>
            '${entry.key.toRadixString(16)}: ${getNiceHexArray(entry.value)}')
        .join(', ')
        .toUpperCase();
  }

  String getNiceServiceData(Map<Guid, List<int>> data) {
    return data.entries
        .map((v) => '${v.key}: ${getNiceHexArray(v.value)}')
        .join(', ')
        .toUpperCase();
  }

  String getNiceServiceUuids(List<Guid> serviceUuids) {
    return serviceUuids.join(', ').toUpperCase();
  }

  bool get isConnected {
    return widget.result.isConnected;
  }

  Widget _buildTitle(BuildContext context) {
    if (widget.result.name.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.result.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            widget.result.id,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      );
    } else {
      return Text(widget.result.id);
    }
  }

  Widget _buildConnectButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      onPressed: widget.onTap,
      child: isConnected ? const Text('OPEN') : const Text('CONNECT'),
    );
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dev = widget.result;
    return ExpansionTile(
      title: _buildTitle(context),
      leading: Text(widget.result.rssi.toString()),
      trailing: _buildConnectButton(context),
      children: <Widget>[
        if (dev.name.isNotEmpty) _buildAdvRow(context, 'Name', dev.name),
      ],
    );
  }
}

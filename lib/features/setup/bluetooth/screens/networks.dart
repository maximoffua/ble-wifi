import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:minigro/features/setup/bluetooth/models/adapter.dart';
import 'package:minigro/features/setup/bluetooth/models/service.dart';
import 'package:minigro/globals/bluetooth.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../../../../globals/getit.dart';

@RoutePage()
class NetworksScreen extends StatefulWidget {
  const NetworksScreen({
    super.key,
    required this.device,
  });

  final DiscoveredDevice device;

  @override
  State<NetworksScreen> createState() => NetworksScreenState();
}

class NetworksScreenState extends State<NetworksScreen> {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;

  final Talker talker = getIt();

  @override
  void initState() {
    super.initState();
    _startScan(context);
    _getScannedResults(context);
    _startListeningToScanResults(context);
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  Future<void> _startScan(BuildContext context) async {
    final can = await WiFiScan.instance.canStartScan();
    // if can-not, then show error
    if (can != CanStartScan.yes) {
      talker.error("Cannot start scan: $can");
      return;
    }
    await WiFiScan.instance.startScan();
    setState(() => accessPoints = <WiFiAccessPoint>[]);
  }

  Future<void> _getScannedResults(BuildContext context) async {
    final results = await WiFiScan.instance.getScannedResults();
    setState(() => accessPoints = results);
  }

  Future<void> _startListeningToScanResults(BuildContext context) async {
    subscription = WiFiScan.instance.onScannedResultsAvailable.listen(
      (result) {
        setState(() => accessPoints = result);
      },
    );
  }

  // void _stopListeningToScanResults() {
  //   subscription?.cancel();
  //   if (mounted) {
  //     setState(() => subscription = null);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WI-FI'),
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.perm_scan_wifi),
                    label: const Text('Scan network'),
                    onPressed: () async => _startScan(context),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                    onPressed: () async => _getScannedResults(context),
                  ),
                ],
              ),
              const Divider(),
              Flexible(
                child: Center(
                  child: accessPoints.isEmpty
                      ? const Text("NO SCANNED RESULTS")
                      : ListView.builder(
                          itemCount: accessPoints.length,
                          itemBuilder: (context, i) => _AccessPointTile(
                                key: Key(i.toString()),
                                accessPoint: accessPoints[i],
                                onTap: (creds) async {
                                  final service = (await widget.device.services)
                                      .firstWhere((element) =>
                                          element.id == Guid(miniGroService));
                                  final ssid = (await service.characteristics)
                                      .firstWhere((element) =>
                                          element.id == MiniGroService.ssid);
                                  final pass = (await service.characteristics)
                                      .firstWhere((element) =>
                                          element.id ==
                                          MiniGroService.password);
                                  talker.info(
                                      "Connecting to ${creds.ssid}\n  using password: ${creds.password}");
                                  await ssid.write(creds.ssid);
                                  await pass.write(creds.password);
                                  talker.info("SSID ${await ssid.read()}");
                                },
                              )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Can see details when tapped.
class _AccessPointTile extends StatefulWidget {
  final WiFiAccessPoint accessPoint;

  final ValueChanged<WiFiCredentials> onTap;

  const _AccessPointTile(
      {super.key, required this.accessPoint, required this.onTap});

  @override
  State<_AccessPointTile> createState() => _AccessPointTileState();
}

class _AccessPointTileState extends State<_AccessPointTile> {
  late TextEditingController _wifiPasswordController;
  final Talker talker = getIt();

  @override
  void initState() {
    super.initState();
    _wifiPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _wifiPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.accessPoint.ssid.isNotEmpty
        ? widget.accessPoint.ssid
        : "**HIDDEN**";
    final signalIcon = widget.accessPoint.level >= -80
        ? Icons.signal_wifi_4_bar
        : Icons.signal_wifi_0_bar;
    return ListTile(
      visualDensity: VisualDensity.comfortable,
      leading: Icon(
        signalIcon,
        size: 30,
      ),
      title: Text(title, style: const TextStyle(fontSize: 18.0)),
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('SSID: $title'),
          titleTextStyle: const TextStyle(fontSize: 22, color: Colors.black),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 20.0),
            TextField(
              controller: _wifiPasswordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a WI-FI password',
              ),
            ),
            const SizedBox(height: 20.0),
            FilledButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  elevation: 20,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () => {
                      context.popRoute(
                          WiFiCredentials(title, _wifiPasswordController.text)),
                      talker.info('SSID: $title'),
                      talker.info(_wifiPasswordController.text)
                    },
                child: const Text('Connect')),
          ]),
        ),
      ).then((value) => value ? widget.onTap(value) : value),
    );
  }
}

class WiFiCredentials {
  final String ssid;
  final String password;

  WiFiCredentials(this.ssid, this.password);
}

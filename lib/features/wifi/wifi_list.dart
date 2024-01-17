import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minigro/features/wifi/providers/wifi.dart';
import 'package:minigro/globals/getit.dart';
import 'package:minigro/routes/root.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:wifi_scan/wifi_scan.dart';

import 'providers/networks.dart';

@RoutePage(name: 'WifiListRoute')
class WifiList extends ConsumerStatefulWidget {
  const WifiList({super.key});

  @override
  ConsumerState<WifiList> createState() => _WifiListState();
}

class _WifiListState extends ConsumerState<WifiList> {
  Widget viewData(BuildContext context, List<WiFiAccessPoint> accessPoints) {
    return Center(
      child: accessPoints.isEmpty
          ? const Text("NO SCANNED RESULTS")
          : ListView.builder(
              itemCount: accessPoints.length,
              itemBuilder: (context, i) =>
                  AccessPointTile(accessPoint: accessPoints[i])),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scanning = ref.watch(wifiScanningProvider);
    if (scanning.hasError) {
      log.error("Failed to get wifi scanning state", scanning.error);
    }
    final networks = ref.watch(availableNetworksProvider);
    if (networks.hasError) {
      log.error("Failed to get wifi networks", networks.error);
    }
    return TalkerWrapper(
      talker: getIt(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Wifi List")),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: Center(
              child: switch (networks) {
            AsyncData(:final value) => viewData(
                context,
                // filter out empty SSIDs
                value.where((ap) => ap.ssid.isNotEmpty).toList()
                  // sort by signal strength, strongest first
                  ..sort(
                    (a, b) => b.level - a.level,
                  )),
            AsyncLoading() => const Center(child: CircularProgressIndicator()),
            AsyncError() => const Placeholder(strokeWidth: .0),
          }),
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    ref.read(wifiScanningProvider.notifier).startScan();
  }
}

/// Show tile for AccessPoint.
///
/// Can see details when tapped.
class AccessPointTile extends StatelessWidget {
  final WiFiAccessPoint accessPoint;

  const AccessPointTile({super.key, required this.accessPoint});

  // build row that can display info, based on label: value pair.
  Widget buildInfo(String label, dynamic value) => Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(child: Text(value.toString()))
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final title = accessPoint.ssid.isNotEmpty ? accessPoint.ssid : "**EMPTY**";
    final signalIcon = switch (accessPoint.level) {
      < -90 => Icons.signal_wifi_0_bar,
      < -80 => Icons.network_wifi_1_bar,
      < -70 => Icons.network_wifi_2_bar,
      < -60 => Icons.network_wifi_3_bar,
      < -50 => Icons.signal_wifi_4_bar,
      _ => Icons.signal_wifi_4_bar,
    };
    final router = AutoRouter.of(context);
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Icon(signalIcon),
      title: Text(title),
      subtitle: Text(accessPoint.capabilities),
      onTap: () async {
        log.debug("Tapped on $accessPoint");
        final password = await showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 150),
                child: const PasswordPrompt()),
          ),
        );
        log.debug("Password: $password");
        if (password != null) {
          router.push(FinalRoute(network: accessPoint, password: password));
        }
      },
    );
  }
}

class PasswordPrompt extends StatefulWidget {
  const PasswordPrompt({super.key});

  @override
  State<PasswordPrompt> createState() => _PasswordPromptState();
}

class _PasswordPromptState extends State<PasswordPrompt> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          obscureText: true,
          controller: _controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Password',
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () {
            context.popRoute(_controller.text);
          },
          child: const Text('Connect'),
        ),
      ],
    );
  }
}

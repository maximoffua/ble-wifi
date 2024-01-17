import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wifi_scan/wifi_scan.dart';

@RoutePage(name: 'FinalRoute')
class FinalScreen extends ConsumerStatefulWidget {
  final String? password;
  final WiFiAccessPoint network;

  const FinalScreen({super.key, required this.network, this.password});

  @override
  ConsumerState<FinalScreen> createState() => _FinalScreenState();
}

class _FinalScreenState extends ConsumerState<FinalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.routeData.name),
        leading: const AutoLeadingButton(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Network: ${widget.network.ssid}"),
            Text("Password: ${widget.password}"),
          ],
        ),
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:minigro/routes/root.dart';

@RoutePage(name: 'GettingStartedRoute')
class GettingStarted extends StatefulWidget {
  const GettingStarted({super.key});

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(router.current.title(context)),
        leading: const AutoLeadingButton(),
      ),
      body: const Center(child: Text('Getting Started')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => router.push(const WifiListRoute()),
        child: const Icon(Icons.wifi),
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sandbox/router/root.dart';
import 'package:sandbox/services/global.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../widgets/scaffold.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 1;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    if (_counter % 7 == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: SnackbarContent(
        title: 'Test',
        message: 'Message error',
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (_counter % 3 == 0) {
        throw Exception("test talker");
      }
    } catch (e) {
      getIt<Talker>().handle(e);
    }

    return GrovScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushRoute(BleRoute()),
        tooltip: 'Add device',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

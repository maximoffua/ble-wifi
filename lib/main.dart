import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sandbox/router/root.dart';
import 'package:sandbox/services/global.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  final talker = TalkerFlutter.init();
  sl.registerSingleton(talker);

  final root = RootRouter();
  sl.registerSingleton(root);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sandbox',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        useMaterial3: true,
      ),
      routerConfig: getIt<RootRouter>()
          .config(navigatorObservers: () => [TalkerRouteObserver(getIt())]),
    );
  }
}

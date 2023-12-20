import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../features/home/screen.dart';
import '../features/setup/screen.dart';
import '../features/setup/screens/networks.dart';

part 'root.gr.dart';

@AutoRouterConfig()
class RootRouter extends _$RootRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: BleRoute.page),
        AutoRoute(page: ScanRoute.page),
        AutoRoute(page: DeviceRoute.page),
        AutoRoute(page: BluetoothOffRoute.page),
        AutoRoute(page: NetworksRoute.page),
      ];
}

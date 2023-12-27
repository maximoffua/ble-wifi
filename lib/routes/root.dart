// root auto router

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:minigro/features/setup/bluetooth/models/adapter.dart';

import '../features/onboarding/screens/initial.dart';
import '../features/screens.dart';

part 'root.gr.dart';

@lazySingleton
@AutoRouterConfig()
class RootRouter extends _$RootRouter {
  RootRouter() : super();

  @override
  List<AutoRoute> get routes => [
        // initial route is named "/"
        AutoRoute(page: DeviceListRoute.page, initial: true),
        AutoRoute(page: GettingStartedRoute.page),
      ];
}

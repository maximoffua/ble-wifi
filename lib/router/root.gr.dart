// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'root.dart';

abstract class _$RootRouter extends RootStackRouter {
  // ignore: unused_element
  _$RootRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    BleRoute.name: (routeData) {
      final args =
          routeData.argsAs<BleRouteArgs>(orElse: () => const BleRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: BleScreen(key: args.key),
      );
    },
    BluetoothOffRoute.name: (routeData) {
      final args = routeData.argsAs<BluetoothOffRouteArgs>(
          orElse: () => const BluetoothOffRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: BluetoothOffScreen(
          key: args.key,
          adapterState: args.adapterState,
        ),
      );
    },
    DeviceRoute.name: (routeData) {
      final args = routeData.argsAs<DeviceRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DeviceScreen(
          key: args.key,
          device: args.device,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    NetworksRoute.name: (routeData) {
      final args = routeData.argsAs<NetworksRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NetworksScreen(
          key: args.key,
          device: args.device,
        ),
      );
    },
    ScanRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ScanScreen(),
      );
    },
  };
}

/// generated route for
/// [BleScreen]
class BleRoute extends PageRouteInfo<BleRouteArgs> {
  BleRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          BleRoute.name,
          args: BleRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'BleRoute';

  static const PageInfo<BleRouteArgs> page = PageInfo<BleRouteArgs>(name);
}

class BleRouteArgs {
  const BleRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'BleRouteArgs{key: $key}';
  }
}

/// generated route for
/// [BluetoothOffScreen]
class BluetoothOffRoute extends PageRouteInfo<BluetoothOffRouteArgs> {
  BluetoothOffRoute({
    Key? key,
    BluetoothAdapterState? adapterState,
    List<PageRouteInfo>? children,
  }) : super(
          BluetoothOffRoute.name,
          args: BluetoothOffRouteArgs(
            key: key,
            adapterState: adapterState,
          ),
          initialChildren: children,
        );

  static const String name = 'BluetoothOffRoute';

  static const PageInfo<BluetoothOffRouteArgs> page =
      PageInfo<BluetoothOffRouteArgs>(name);
}

class BluetoothOffRouteArgs {
  const BluetoothOffRouteArgs({
    this.key,
    this.adapterState,
  });

  final Key? key;

  final BluetoothAdapterState? adapterState;

  @override
  String toString() {
    return 'BluetoothOffRouteArgs{key: $key, adapterState: $adapterState}';
  }
}

/// generated route for
/// [DeviceScreen]
class DeviceRoute extends PageRouteInfo<DeviceRouteArgs> {
  DeviceRoute({
    Key? key,
    required BluetoothDevice device,
    List<PageRouteInfo>? children,
  }) : super(
          DeviceRoute.name,
          args: DeviceRouteArgs(
            key: key,
            device: device,
          ),
          initialChildren: children,
        );

  static const String name = 'DeviceRoute';

  static const PageInfo<DeviceRouteArgs> page = PageInfo<DeviceRouteArgs>(name);
}

class DeviceRouteArgs {
  const DeviceRouteArgs({
    this.key,
    required this.device,
  });

  final Key? key;

  final BluetoothDevice device;

  @override
  String toString() {
    return 'DeviceRouteArgs{key: $key, device: $device}';
  }
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NetworksScreen]
class NetworksRoute extends PageRouteInfo<NetworksRouteArgs> {
  NetworksRoute({
    Key? key,
    required BluetoothDevice device,
    List<PageRouteInfo>? children,
  }) : super(
          NetworksRoute.name,
          args: NetworksRouteArgs(
            key: key,
            device: device,
          ),
          initialChildren: children,
        );

  static const String name = 'NetworksRoute';

  static const PageInfo<NetworksRouteArgs> page =
      PageInfo<NetworksRouteArgs>(name);
}

class NetworksRouteArgs {
  const NetworksRouteArgs({
    this.key,
    required this.device,
  });

  final Key? key;

  final BluetoothDevice device;

  @override
  String toString() {
    return 'NetworksRouteArgs{key: $key, device: $device}';
  }
}

/// generated route for
/// [ScanScreen]
class ScanRoute extends PageRouteInfo<void> {
  const ScanRoute({List<PageRouteInfo>? children})
      : super(
          ScanRoute.name,
          initialChildren: children,
        );

  static const String name = 'ScanRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

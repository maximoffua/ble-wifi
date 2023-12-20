// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scanResultsHash() => r'1267ae79c5782c9e7246e78c388231cc7df73872';

/// See also [scanResults].
@ProviderFor(scanResults)
final scanResultsProvider =
    AutoDisposeStreamProvider<List<ScanResult>>.internal(
  scanResults,
  name: r'scanResultsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$scanResultsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ScanResultsRef = AutoDisposeStreamProviderRef<List<ScanResult>>;
String _$scanningHash() => r'9d6cb9cb6c64b953040c0807a009555660ec6a80';

/// See also [scanning].
@ProviderFor(scanning)
final scanningProvider = AutoDisposeStreamProvider<bool>.internal(
  scanning,
  name: r'scanningProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$scanningHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ScanningRef = AutoDisposeStreamProviderRef<bool>;
String _$adapterStateHash() => r'c26dc9e06a27166e4e18d8070c42ace9c0e55fc9';

/// See also [adapterState].
@ProviderFor(adapterState)
final adapterStateProvider =
    AutoDisposeStreamProvider<BluetoothAdapterState>.internal(
  adapterState,
  name: r'adapterStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$adapterStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AdapterStateRef = AutoDisposeStreamProviderRef<BluetoothAdapterState>;
String _$systemDevicesHash() => r'72519284ee8a948ffed7246a296f210e52689b99';

/// See also [systemDevices].
@ProviderFor(systemDevices)
final systemDevicesProvider =
    AutoDisposeFutureProvider<List<BluetoothDevice>>.internal(
  systemDevices,
  name: r'systemDevicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$systemDevicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SystemDevicesRef = AutoDisposeFutureProviderRef<List<BluetoothDevice>>;
String _$bleServiceHash() => r'46d8fa8ab360c7f0ebfa9d95e4f608c42cd8cf93';

/// See also [BleService].
@ProviderFor(BleService)
final bleServiceProvider =
    AutoDisposeAsyncNotifierProvider<BleService, void>.internal(
  BleService.new,
  name: r'bleServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bleServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BleService = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package

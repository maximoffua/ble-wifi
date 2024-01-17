import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wifi_scan/wifi_scan.dart';

part 'networks.g.dart';

@riverpod
Stream<List<WiFiAccessPoint>> availableNetworks(AvailableNetworksRef ref) {
  return WiFiScan.instance.onScannedResultsAvailable;
}

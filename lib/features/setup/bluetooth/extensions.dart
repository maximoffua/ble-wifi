import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:minigro/utils/streams.dart';

final Map<DeviceIdentifier, StreamControllerReEmit<bool>> _cglobal = {};
final Map<DeviceIdentifier, StreamControllerReEmit<bool>> _dglobal = {};

/// connect & disconnect + update stream
extension Extra on BluetoothDevice {
  // convenience
  StreamControllerReEmit<bool> get _cstream {
    _cglobal[remoteId] ??= StreamControllerReEmit(initialValue: false);
    return _cglobal[remoteId]!;
  }

  // convenience
  StreamControllerReEmit<bool> get _dstream {
    _dglobal[remoteId] ??= StreamControllerReEmit(initialValue: false);
    return _dglobal[remoteId]!;
  }

  // get stream
  Stream<bool> get isConnecting {
    return _cstream.stream;
  }

  // get stream
  Stream<bool> get isDisconnecting {
    return _dstream.stream;
  }

  // connect & update stream
  Future<void> connectAndUpdateStream() async {
    _cstream.add(true);
    try {
      await connect(mtu: null);
    } finally {
      _cstream.add(false);
    }
  }

  // disconnect & update stream
  Future<void> disconnectAndUpdateStream({bool queue = true}) async {
    _dstream.add(true);
    try {
      await disconnect(queue: queue);
    } finally {
      _dstream.add(false);
    }
  }
}

extension Stringer on List<int> {
  String toHexString() =>
      map((e) => e.toRadixString(16).padLeft(2, '0')).join();

  String asString() => String.fromCharCodes(this);
}

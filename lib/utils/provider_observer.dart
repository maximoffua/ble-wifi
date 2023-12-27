import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker/talker.dart';

class TalkerObserver implements ProviderObserver {
  final Talker talker;

  TalkerObserver(this.talker);

  @override
  void providerDidFail(ProviderBase<Object?> provider, Object error,
      StackTrace stackTrace, ProviderContainer container) {
    talker.error(
      "Provider failed!\n"
      "  depth: ${container.depth}\n"
      "  container: ${container.toString()}",
      error,
      stackTrace,
    );
  }

  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value,
      ProviderContainer container) {
    talker.debug(
      "Provider created!\n"
      "  depth: ${container.depth}\n"
      "  container: ${container.toString()}\n"
      "  value: $value",
    );
  }

  @override
  void didDisposeProvider(
      ProviderBase<Object?> provider, ProviderContainer container) {
    talker.debug("Provider disposed!\n"
        "  depth: ${container.depth}\n"
        "  container: ${container.toString()}");
  }

  @override
  void didUpdateProvider(ProviderBase<Object?> provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    talker.debug("Provider updated!\n"
        "  depth: ${container.depth}\n"
        "  container: ${container.toString()}\n"
        "  value: $newValue\n"
        "  previousValue: $previousValue");
  }
}

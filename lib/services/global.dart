import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

T getIt<T extends Object>({
  dynamic param1,
  dynamic param2,
  String? instanceName,
  Type? type,
}) {
  return sl.get<T>(
    instanceName: instanceName,
    param1: param1,
    param2: param2,
  );
}

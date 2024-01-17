import 'package:get_it/get_it.dart';
import 'package:talker/talker.dart';

export 'package:talker/talker.dart';

final sl = GetIt.instance;

T getIt<T extends Object>({
  String? instanceName,
  dynamic param1,
  dynamic param2,
  Type? type,
}) =>
    sl.get<T>(
      instanceName: instanceName,
      param1: param1,
      param2: param2,
      type: type,
    );

Future<T> getItA<T extends Object>({
  String? instanceName,
  dynamic param1,
  dynamic param2,
  Type? type,
}) =>
    sl.getAsync<T>(
      instanceName: instanceName,
      param1: param1,
      param2: param2,
      type: type,
    );

Talker get log => getIt<Talker>();

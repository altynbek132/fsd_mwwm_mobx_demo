import 'dart:async';

import 'package:utils/utils_dart.dart';

Future<T> trace<T>(String name, Future<T> Function() block, {bool microseconds = false}) async {
  final stopwatch = Stopwatch()..start();
  try {
    return await block();
  } finally {
    stopwatch.stop();
    loggerGlobal.d(
        'Trace "$name" took ${microseconds ? '${stopwatch.elapsedMicroseconds} mqs' : '${stopwatch.elapsedMilliseconds} ms'}');
  }
}

Stream<T> traceStream<T>(String name, Stream<T> Function() block, {bool microseconds = false}) async* {
  final stopwatch = Stopwatch()..start();
  try {
    yield* block();
  } finally {
    stopwatch.stop();
    loggerGlobal.d(
        'Trace "$name" took ${microseconds ? '${stopwatch.elapsedMicroseconds} mqs' : '${stopwatch.elapsedMilliseconds} ms'}');
  }
}

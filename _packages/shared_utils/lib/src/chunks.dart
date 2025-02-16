// file hello_world.dart

import 'dart:async';
import 'dart:typed_data';

Stream<Uint8List> bytesToChunks(Uint8List bytes, [int? chunkSizeInBytes]) async* {
  if (chunkSizeInBytes == null) {
    yield bytes;
    return;
  }
  for (var i = 0; i < bytes.length; i += chunkSizeInBytes) {
    final end = (i + chunkSizeInBytes < bytes.length) ? i + chunkSizeInBytes : bytes.length;
    yield bytes.sublist(i, end);
  }
}

Future<Uint8List?> chunksToBytes(Stream<Uint8List> chunks) async {
  final lists = await chunks.toList();
  if (lists.isEmpty) return null;
  final builder = BytesBuilder();
  for (final list in lists) {
    builder.add(list);
  }
  return builder.toBytes();
}

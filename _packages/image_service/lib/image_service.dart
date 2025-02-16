import 'dart:async';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:shared_utils/shared_utils.dart';
import 'package:squadron/squadron.dart';

import 'image_service.activator.g.dart';
part 'image_service.worker.g.dart';

@SquadronService(baseUrl: '~/workers', targetPlatform: TargetPlatform.vm | TargetPlatform.web)
base class ImageService {
  final _builder = BytesBuilder();

  @SquadronMethod()
  Future<void> cropImageToAspectRatioSendBytes({
    required Uint8List bytes,
  }) async {
    _builder.add(bytes);
  }

  @SquadronMethod()
  Stream<Uint8List> cropImageToAspectRatioProcess({
    required double aspectRatio,
    required bool shouldFlipHorizontal,
    int? chunkSizeInBytes,
  }) async* {
    final bytes = _builder.toBytes();
    _builder.clear();
    yield* _cropImageToAspectRatio(
      imageBytes: bytes,
      aspectRatio: aspectRatio,
      shouldFlipHorizontal: shouldFlipHorizontal,
      chunkSizeInBytes: chunkSizeInBytes,
    );
  }

  Stream<Uint8List> _cropImageToAspectRatio({
    required Uint8List imageBytes,
    required double aspectRatio,
    required bool shouldFlipHorizontal,
    int? chunkSizeInBytes,
  }) async* {
    yield* traceStream(
      'ImageService.cropImageToAspectRatio',
      () async* {
        var image = decodeImage(imageBytes);

        if (image == null) {
          return;
        }

        // Flip the image if using front camera
        if (shouldFlipHorizontal) {
          image = flipHorizontal(image);
        }

        final originalWidth = image.width;
        final originalHeight = image.height;

        double newWidth;
        double newHeight;

        if (originalWidth / originalHeight > aspectRatio) {
          newHeight = originalHeight.toDouble();
          newWidth = newHeight * aspectRatio;
        } else {
          newWidth = originalWidth.toDouble();
          newHeight = newWidth / aspectRatio;
        }

        final x = (originalWidth - newWidth) ~/ 2;
        final y = (originalHeight - newHeight) ~/ 2;

        final resImage = copyCrop(
          image,
          x: x.toInt(),
          y: y.toInt(),
          width: newWidth.toInt(),
          height: newHeight.toInt(),
        );

        final resImageBytes = encodePng(resImage);

        if (chunkSizeInBytes == null) {
          yield resImageBytes;
          return;
        }

        // Yield bytes in chunks
        yield* bytesToChunks(resImageBytes, chunkSizeInBytes);
      },
    );
  }

  @SquadronMethod()
  Future<Uint8List> getEmptyBytes(int bytes) async {
    return Uint8List(bytes);
  }

  @SquadronMethod()
  Future<void> sendEmptyBytes(Uint8List bytes) async {}
}

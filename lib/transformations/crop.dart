import 'dart:typed_data';

import '../bitmap.dart';

Bitmap cropLTWH(
  Bitmap bitmap,
  int cropLeft,
  int cropTop,
  int cropWidth,
  int cropHeight,
) {
  assert(cropLeft >= 0);
  assert(cropTop >= 0);
  assert(cropWidth > 0);
  assert(cropHeight > 0);
  assert(cropLeft + cropWidth <= bitmap.width);
  assert(cropTop + cropHeight <= bitmap.height);

  final int newBitmapSize = cropWidth * cropHeight * bitmapPixelLength;

  final Bitmap cropped = Bitmap.fromHeadless(
    cropWidth,
    cropHeight,
    Uint8List(newBitmapSize),
  );

  cropCore(
    bitmap.content,
    cropped.content,
    bitmap.width, // Height is not needed.
    cropLeft,
    cropTop,
    cropWidth,
    cropHeight,
  );

  return cropped;
}

Bitmap cropLTRB(
  Bitmap bitmap,
  int cropLeft,
  int cropTop,
  int cropRight,
  int cropBottom,
) =>
    cropLTWH(
      bitmap,
      cropLeft,
      cropTop,
      cropRight - cropLeft,
      cropBottom - cropTop,
    );

void cropCore(
  Uint8List sourceBmp,
  Uint8List destBmp,
  int sourceWidth,
  int left,
  int top,
  int width,
  int height,
) {
  for (int x = left * bitmapPixelLength;
      x < (left + width) * bitmapPixelLength;
      x++) {
    for (int y = top; y < (top + height); y++) {
      destBmp[x -
              left * bitmapPixelLength +
              (y - top) * width * bitmapPixelLength] =
          sourceBmp[x + y * sourceWidth * bitmapPixelLength];
    }
  }
}

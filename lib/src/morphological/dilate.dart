import 'package:dart_opencv_sdk/src/morphological/morphological.dart';
import 'package:image/image.dart';

import '../core/functions.dart';

class Dilating implements MorpHological {
  final int iterations;

  final CoreFunctions coreFunctions;

  Dilating({this.iterations = 1}) : coreFunctions = CoreFunctions();
  @override
  Image applyFilter(Image image) {
    final dilatedImage = Image.from(image);

    for (var iteration = 0; iteration < iterations; iteration++) {
      for (var y = 1; y < image.height - 1; y++) {
        for (var x = 1; x < image.width - 1; x++) {
          final pixel = image.getPixel(x, y);

          final neighbor1 = image.getPixel(x - 1, y);
          final neighbor2 = image.getPixel(x + 1, y);
          final neighbor3 = image.getPixel(x, y - 1);
          final neighbor4 = image.getPixel(x, y + 1);

          if (pixel.r == 255 ||
              neighbor1.r == 255 ||
              neighbor2.r == 255 ||
              neighbor3.r == 255 ||
              neighbor4.r == 255) {
            dilatedImage.setPixel(x, y, ColorFloat64.rgb(255, 255, 255));
          }
        }
      }

      image = Image.from(dilatedImage);
    }

    return dilatedImage;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
import 'package:dart_opencv_sdk/src/morphological/morphological.dart';
import 'package:image/image.dart';

class Eroding implements MorpHological {
  final int iterations;

  Eroding({this.iterations = 1});

  @override
  Image applyFilter(Image image) {
    final erodedImage = Image.from(image);

    for (var iteration = 0; iteration < iterations; iteration++) {
      for (var y = 1; y < image.height - 1; y++) {
        for (var x = 1; x < image.width - 1; x++) {
          final pixel = image.getPixel(x, y);

          final neighbor1 = image.getPixel(x - 1, y);
          final neighbor2 = image.getPixel(x + 1, y);
          final neighbor3 = image.getPixel(x, y - 1);
          final neighbor4 = image.getPixel(x, y + 1);

          if (pixel.r == 0 ||
              neighbor1.r == 0 ||
              neighbor2.r == 0 ||
              neighbor3.r == 0 ||
              neighbor4.r == 0) {
            erodedImage.setPixel(x, y, ColorFloat64.rgb(0, 0, 0));
          }
        }
      }

      image = Image.from(erodedImage);
    }

    return erodedImage;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

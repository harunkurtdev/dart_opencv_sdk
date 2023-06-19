import 'package:image/image.dart';
import '../core/functions.dart';
import 'blur.dart';

class MedianBlurFilter implements SmoothFilter {
  final CoreFunctions coreFunctions;
  final int radius;
  final int kernelSize;

  MedianBlurFilter({this.radius = 2})
      : kernelSize = radius * 2 + 1,
        coreFunctions = CoreFunctions();

  @override
  Image applyFilter(Image image) {
    final filteredImage = Image(width: image.width, height: image.height);

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final filteredPixel = applyMedianFilter(image, x, y);
        filteredImage.setPixel(x, y,
            ColorFloat64.rgb(filteredPixel, filteredPixel, filteredPixel));
      }
    }

    return filteredImage;
  }

  int applyMedianFilter(Image image, int x, int y) {
    final pixelValues = <int>[];

    for (var i = -radius; i <= radius; i++) {
      for (var j = -radius; j <= radius; j++) {
        final pixel = coreFunctions.getPixelSafer(image, x + j, y + i);
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;

        final grayValue = (r + g + b) ~/ 3;
        pixelValues.add(grayValue);
      }
    }

    pixelValues.sort();

    final medianIndex = (pixelValues.length / 2).floor();
    final filteredValue = pixelValues[medianIndex];

    return filteredValue;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

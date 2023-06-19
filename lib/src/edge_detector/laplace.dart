import 'package:image/image.dart';

import '../core/functions.dart';
import '../filter/filter.dart';

// https://docs.opencv.org/3.4/d5/db5/tutorial_laplace_operator.html
class LaplaceFilter extends ImageFilter {
  final CoreFunctions coreFunctions;
  final List<List<int>> laplaceKernel = [
    [0, 1, 0],
    [1, -4, 1],
    [0, 1, 0]
  ];

  LaplaceFilter() : coreFunctions = CoreFunctions();

  @override
  Image applyFilter(Image image) {
    final filteredImage = Image(width: image.width, height: image.height);

    for (var y = 1; y < image.height - 1; y++) {
      for (var x = 1; x < image.width - 1; x++) {
        final sum = calculateSum(image, x, y);

        final filteredPixel = sum.clamp(0, 255).toInt();
        final filteredColor =
            ColorFloat64.rgb(filteredPixel, filteredPixel, filteredPixel);
        filteredImage.setPixel(x, y, filteredColor);
      }
    }

    return filteredImage;
  }

  int calculateSum(Image image, int x, int y) {
    var sum = 0;

    for (var ky = -1; ky <= 1; ky++) {
      for (var kx = -1; kx <= 1; kx++) {
        final pixel = coreFunctions.getPixelSafer(image, x + kx, y + ky);
        final kernelValue = laplaceKernel[ky + 1][kx + 1];
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;
        final luminance = ((0.299 * r) + (0.587 * g) + (0.114 * b)).toInt();
        sum += luminance * kernelValue;
      }
    }

    return sum;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

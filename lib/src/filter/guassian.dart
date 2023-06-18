import 'package:image/image.dart';

import 'filter.dart';
import 'dart:math';

// https://docs.opencv.org/4.x/d4/d13/tutorial_py_filtering.html
class GaussianBlurFilter implements ImageFilter {
  final double sigma;
  final int radius;
  final int kernelSize;

  GaussianBlurFilter({this.sigma = 2.0, this.radius = 2})
      : kernelSize = radius * 2 + 1;

  @override
  Image applyFilter(Image image) {
    final filteredImage = Image(width: image.width, height: image.height);

    final kernel = generateKernel();

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final filteredPixel = applyKernel(image, x, y, kernel);
        filteredImage.setPixel(x, y,
            ColorFloat16.rgb(filteredPixel, filteredPixel, filteredPixel));
      }
    }

    return filteredImage;
  }

  List<List<double>> generateKernel() {
    final kernel =
        List.generate(kernelSize, (_) => List.filled(kernelSize, 0.0));

    final double sigmaSquared = sigma * sigma;
    final double twoSigmaSquared = 2 * sigmaSquared;

    final double coefficient = 1 / (twoSigmaSquared * 3.14159265359);

    double total = 0;

    for (var i = -radius; i <= radius; i++) {
      for (var j = -radius; j <= radius; j++) {
        final exponent = -(i * i + j * j) / twoSigmaSquared;
        final value = coefficient * exp(exponent);
        kernel[i + radius][j + radius] = value;
        total += value;
      }
    }

    final normalizationFactor = 1 / total;

    for (var i = 0; i < kernelSize; i++) {
      for (var j = 0; j < kernelSize; j++) {
        kernel[i][j] *= normalizationFactor;
      }
    }

    return kernel;
  }

  int applyKernel(Image image, int x, int y, List<List<double>> kernel) {
    var sumR = 0.0;
    var sumG = 0.0;
    var sumB = 0.0;

    for (var i = -radius; i <= radius; i++) {
      for (var j = -radius; j <= radius; j++) {
        final pixel = getPixelSafer(image, x + j, y + i);
        final weight = kernel[i + radius][j + radius];
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;

        sumR += r * weight;
        sumG += g * weight;
        sumB += b * weight;
      }
    }

    final filteredR = sumR.round().clamp(0, 255).toInt();
    final filteredG = sumG.round().clamp(0, 255).toInt();
    final filteredB = sumB.round().clamp(0, 255).toInt();

    return getColors(filteredR, filteredG, filteredB);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

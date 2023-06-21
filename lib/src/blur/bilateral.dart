import 'dart:math';

import 'package:image/image.dart';
import '../core/functions.dart';
import 'blur.dart';

class BilateralFilter implements SmoothFilter {
  final CoreFunctions coreFunctions;
  final double sigmaSpace;
  final double sigmaColor;
  final int radius;
  final int kernelSize;

  BilateralFilter(
      {this.sigmaSpace = 2.0, this.sigmaColor = 30.0, this.radius = 2})
      : kernelSize = radius * 2 + 1,
        coreFunctions = CoreFunctions();

  @override
  Image applyFilter(Image image) {
    final filteredImage = Image(width: image.width, height: image.height);

    final kernelSpace = generateSpaceKernel();
    final maxColorDiff = calculateMaxColorDifference();

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final filteredPixel =
            applyBilateralFilter(image, x, y, kernelSpace, maxColorDiff);
        filteredImage.setPixel(x, y, filteredPixel);
      }
    }

    return filteredImage;
  }

  List<List<double>> generateSpaceKernel() {
    final kernel =
        List.generate(kernelSize, (_) => List.filled(kernelSize, 0.0));

    final double twoSigmaSquared = 2 * sigmaSpace * sigmaSpace;

    double total = 0;

    for (var i = -radius; i <= radius; i++) {
      for (var j = -radius; j <= radius; j++) {
        final exponent = -(i * i + j * j) / twoSigmaSquared;
        final value = exp(exponent);
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

  double calculateMaxColorDifference() {
    return 3 * sigmaColor;
  }

  Color applyBilateralFilter(Image image, int x, int y,
      List<List<double>> kernelSpace, double maxColorDiff) {
    final centerPixel = coreFunctions.getPixelSafer(image, x, y);
    final centerR = centerPixel.r;
    final centerG = centerPixel.g;
    final centerB = centerPixel.b;

    var sumR = 0.0;
    var sumG = 0.0;
    var sumB = 0.0;
    var totalWeight = 0.0;

    for (var i = -radius; i <= radius; i++) {
      for (var j = -radius; j <= radius; j++) {
        final pixel = coreFunctions.getPixelSafer(image, x + j, y + i);
        final currentR = pixel.r;
        final currentG = pixel.g;
        final currentB = pixel.b;

        final colorDiffSquared = pow(centerR - currentR, 2) +
            pow(centerG - currentG, 2) +
            pow(centerB - currentB, 2);

        final spatialWeight = kernelSpace[i + radius][j + radius];
        final colorWeight =
            exp(-colorDiffSquared / (2 * sigmaColor * sigmaColor));

        final weight = spatialWeight * colorWeight;

        sumR += currentR * weight;
        sumG += currentG * weight;
        sumB += currentB * weight;
        totalWeight += weight;
      }
    }

    final filteredR = (sumR / totalWeight).round().clamp(0, 255);
    final filteredG = (sumG / totalWeight).round().clamp(0, 255);
    final filteredB = (sumB / totalWeight).round().clamp(0, 255);

    return ColorFloat64.rgb(filteredR, filteredG, filteredB);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

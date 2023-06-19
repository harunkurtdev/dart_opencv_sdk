import 'package:dart_opencv_sdk/src/filter/grayscale.dart';
import 'package:image/image.dart';

import '../core/functions.dart';
import '../blur/guassian.dart';
import '../filter/filter.dart';
import 'dart:math';

class CannyEdgeFilter implements ImageFilter {
  final CoreFunctions coreFunctions;
  final double lowThreshold;
  final double highThreshold;
  final int kernelSize;
  final double sigma;

  CannyEdgeFilter({
    this.lowThreshold = 20,
    this.highThreshold = 50,
    this.kernelSize = 3,
    this.sigma = 1.4,
  }) : coreFunctions = CoreFunctions();

  @override
  Image applyFilter(Image image) {
    final grayscaleImage = GrayscaleFilter().applyFilter(image);
    final blurredImage =
        GaussianBlurFilter(sigma: sigma, radius: kernelSize ~/ 2)
            .applyFilter(grayscaleImage);
    final gradients = calculateGradients(blurredImage);
    final suppressedImage = applyNonMaximaSuppression(blurredImage, gradients);
    final thresholdedImage =
        applyDoubleThreshold(suppressedImage, lowThreshold, highThreshold);
    final edgeImage = applyEdgeTrackingByHysteresis(thresholdedImage);

    return edgeImage;
  }

  List<List<double>> calculateGradients(Image image) {
    final sobelX = [
      [-1, 0, 1],
      [-2, 0, 2],
      [-1, 0, 1],
    ];

    final sobelY = [
      [-1, -2, -1],
      [0, 0, 0],
      [1, 2, 1],
    ];

    final gradients = [[]] as List<List<double>>;
    for (var x = 0; x < image.width; x++) {
      gradients[x] = [] as List<double>;
      for (var y = 0; y < image.height; y++) {
        gradients[x][y] = 0;
      }
    }

    for (var y = 1; y < image.height - 1; y++) {
      for (var x = 1; x < image.width - 1; x++) {
        var gx = 0.0;
        var gy = 0.0;

        for (var j = -1; j <= 1; j++) {
          for (var i = -1; i <= 1; i++) {
            final pixel = image.getPixelSafe(x + i, y + j);
            final luminance = pixel.r;
            gx += sobelX[i + 1][j + 1] * luminance;
            gy += sobelY[i + 1][j + 1] * luminance;
          }
        }

        gradients[x][y] = sqrt(gx * gx + gy * gy);
      }
    }

    return gradients;
  }

  Image applyNonMaximaSuppression(Image image, List<List<double>> gradients) {
    final suppressedImage = Image(width: image.width, height: image.height);

    for (var y = 1; y < image.height - 1; y++) {
      for (var x = 1; x < image.width - 1; x++) {
        final pixel = image.getPixel(x, y);
        final pixelValue = pixel.r;

        final angle = atan2(gradients[x][y], gradients[x - 1][y]);
        final direction = (angle * (180 / pi) + 180) % 180;

        final neighbor1 = coreFunctions.getPixelSafer(image, x - 1, y);
        final neighbor2 = coreFunctions.getPixelSafer(image, x + 1, y);

        final neighbor1Value = neighbor1.r;
        final neighbor2Value = neighbor2.r;

        final interpolatedValue = interpolate(pixelValue.toInt(),
            neighbor1Value.toInt(), neighbor2Value.toInt(), direction);
        suppressedImage.setPixel(x, y,
            getColor(interpolatedValue, interpolatedValue, interpolatedValue));
      }
    }

    return suppressedImage;
  }

  int interpolate(int center, int neighbor1, int neighbor2, double direction) {
    final weight = direction % 45 / 45;
    final interpolatedValue =
        ((1 - weight) * neighbor1 + weight * neighbor2).round();

    if (center >= interpolatedValue) {
      return center;
    } else {
      return 0;
    }
  }

  Image applyDoubleThreshold(
      Image image, double lowThreshold, double highThreshold) {
    final thresholdedImage = Image(width: image.width, height: image.height);

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final pixelValue = pixel.r;

        if (pixelValue >= highThreshold) {
          thresholdedImage.setPixel(x, y, getColor(255, 255, 255));
        } else if (pixelValue >= lowThreshold) {
          thresholdedImage.setPixel(x, y, getColor(128, 128, 128));
        } else {
          thresholdedImage.setPixel(x, y, getColor(0, 0, 0));
        }
      }
    }

    return thresholdedImage;
  }

  Image applyEdgeTrackingByHysteresis(Image image) {
    final edgeImage = Image(width: image.width, height: image.height);

    for (var y = 1; y < image.height - 1; y++) {
      for (var x = 1; x < image.width - 1; x++) {
        final pixel = image.getPixel(x, y);
        final pixelValue = pixel.r;

        if (pixelValue == 128) {
          final neighbor1 = coreFunctions.getPixelSafer(image, x - 1, y);
          final neighbor2 = coreFunctions.getPixelSafer(image, x + 1, y);
          final neighbor3 = coreFunctions.getPixelSafer(image, x, y - 1);
          final neighbor4 = coreFunctions.getPixelSafer(image, x, y + 1);

          final neighbor1Value = neighbor1.r;
          final neighbor2Value = neighbor2.r;
          final neighbor3Value = neighbor3.r;
          final neighbor4Value = neighbor4.r;

          if (neighbor1Value == 255 ||
              neighbor2Value == 255 ||
              neighbor3Value == 255 ||
              neighbor4Value == 255) {
            edgeImage.setPixel(x, y, getColor(255, 255, 255));
          } else {
            edgeImage.setPixel(x, y, getColor(0, 0, 0));
          }
        } else {
          edgeImage.setPixel(x, y, getColor(0, 0, 0));
        }
      }
    }

    return edgeImage;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

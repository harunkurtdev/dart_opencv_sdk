import 'package:dart_opencv_sdk/src/edge_detector/edge_detector.dart';
import 'package:image/image.dart';

class SobelFilter implements EdgeDetectorFilter {
  @override
  Image applyFilter(Image image) {
    final filteredImage = Image(width: image.width, height: image.height);

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

    for (var y = 1; y < image.height - 1; y++) {
      for (var x = 1; x < image.width - 1; x++) {
        final gx = calculateGradient(image, x, y, sobelX);
        final gy = calculateGradient(image, x, y, sobelY);

        final magnitude = (gx.abs() + gy.abs()).toInt();
        final filteredColor = ColorFloat64.rgb(magnitude, magnitude, magnitude);
        filteredImage.setPixel(x, y, filteredColor);
      }
    }

    return filteredImage;
  }

  int calculateGradient(Image image, int x, int y, List<List<int>> kernel) {
    var gradient = 0;

    for (var ky = -1; ky <= 1; ky++) {
      for (var kx = -1; kx <= 1; kx++) {
        final pixel = image.getPixel(x + kx, y + ky);
        final kernelValue = kernel[ky + 1][kx + 1];
        final luminance =
            ((0.299 * pixel.r) + (0.587 * pixel.g) + (0.114 * pixel.b)).toInt();
        gradient += luminance * kernelValue;
      }
    }

    return gradient;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

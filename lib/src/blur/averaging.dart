import 'package:image/image.dart';
import '../core/functions.dart';
import 'blur.dart';

class AveragingFilter implements SmoothFilter {
  final CoreFunctions coreFunctions;
  final int radius;
  final int kernelSize;

  AveragingFilter({this.radius = 2})
      : kernelSize = radius * 2 + 1,
        coreFunctions = CoreFunctions();

  @override
  Image applyFilter(Image image) {
    final filteredImage = Image(width: image.width, height: image.height);

    final kernel = generateKernel();

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final filteredPixel = applyKernel(image, x, y, kernel);
        filteredImage.setPixel(x, y,
            ColorFloat64.rgb(filteredPixel, filteredPixel, filteredPixel));
      }
    }

    return filteredImage;
  }

  List<List<int>> generateKernel() {
    final kernel = List.generate(kernelSize, (_) => List.filled(kernelSize, 1));

    return kernel;
  }

  int applyKernel(Image image, int x, int y, List<List<int>> kernel) {
    num sumR = 0;
    num sumG = 0;
    num sumB = 0;

    for (var i = -radius; i <= radius; i++) {
      for (var j = -radius; j <= radius; j++) {
        final pixel = coreFunctions.getPixelSafer(image, x + j, y + i);
        final weight = kernel[i + radius][j + radius];
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;

        sumR += r * weight;
        sumG += g * weight;
        sumB += b * weight;
      }
    }

    final filteredR = (sumR ~/ (kernelSize * kernelSize)).clamp(0, 255);
    final filteredG = (sumG ~/ (kernelSize * kernelSize)).clamp(0, 255);
    final filteredB = (sumB ~/ (kernelSize * kernelSize)).clamp(0, 255);

    return coreFunctions.getColors(filteredR, filteredG, filteredB);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

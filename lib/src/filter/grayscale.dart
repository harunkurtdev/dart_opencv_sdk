import 'package:image/image.dart';
import 'package:image/src/filter/grayscale.dart';

import '../core/functions.dart';
import 'filter.dart';

class GrayscaleFilter implements ImageFilter {
  final CoreFunctions coreFunctions;

  GrayscaleFilter() : coreFunctions = CoreFunctions();
  // @override
  // Image applyFilter(Image image) {
  //   final grayscaleImage = Image(width: image.width, height: image.height);

  //   for (var y = 0; y < image.height; y++) {
  //     for (var x = 0; x < image.width; x++) {
  //       final pixel = image.getPixel(x, y);
  //       final r = pixel.r;
  //       final g = pixel.g;
  //       final b = pixel.b;
  //       final luminance = ((0.299 * r) + (0.587 * g) + (0.114 * b)).toInt();
  //       grayscaleImage.setPixel(
  //           x, y, getColor(luminance, luminance, luminance));
  //     }
  //   }

  //   return grayscaleImage;
  // }

  @override
  Image applyFilter(Image image) {
    Image grayscaleImage = Image(width: image.width, height: image.height);
    grayscaleImage = grayscale(image);
    return grayscaleImage;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

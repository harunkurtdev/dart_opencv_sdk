import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:image/image.dart' as img;

void main() {
  // Resmi yükle
  final image = decodeImage(File('thumbnail_normalize.png').readAsBytesSync())!;
  final filteredImage = laplaceFilter(image);
  File('filtered_resim.jpg').writeAsBytesSync(encodeJpg(filteredImage));


}

Image laplaceFilter(Image image) {
  final laplaceKernel = [
    [0, 1, 0],
    [1, -4, 1],
    [0, 1, 0]
  ];

  final filteredImage = Image(width: image.width, height: image.height);

  for (var y = 1; y < image.height - 1; y++) {
    for (var x = 1; x < image.width - 1; x++) {
      var sum = 0;

      for (var ky = -1; ky <= 1; ky++) {
        for (var kx = -1; kx <= 1; kx++) {
          final pixel = image.getPixel(x + kx, y + ky);
          final kernelValue = laplaceKernel[ky + 1][kx + 1];

          final r = pixel.r;
          final g = pixel.g;
          final b = pixel.b;

          final luminance = ((0.299 * r) + (0.587 * g) + (0.114 * b)).toInt();
          sum += luminance * kernelValue;
        }
      }

      final filteredPixel = sum.clamp(0, 255).toInt();
      Color filtered_color =
          ColorFloat16.rgb(filteredPixel, filteredPixel, filteredPixel);
      filteredImage.setPixel(x, y, filtered_color);
    }
  }

  return filteredImage;
}

// int getColor(int r, int g, int b) {
//   return (r << 16) | (g << 8) | b;
// }

int getRed(int color) {
  return (color >> 16) & 0xFF;
}

int getGreen(int color) {
  return (color >> 8) & 0xFF;
}

int getBlue(int color) {
  return color & 0xFF;
}

int getColor(int r, int g, int b) {
  return (r << 16) | (g << 8) | b;
}

Pixel getPixelSafe(Image image, int x, int y) {
  if (x < 0 || x >= image.width || y < 0 || y >= image.height) {
    return Pixel.undefined;
  }

  return image.getPixelSafe(x, y);
}

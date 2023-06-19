import 'package:image/image.dart';

class CoreFunctions {
  
  int getRed(int color) {
    return (color >> 16) & 0xFF;
  }

  int getGreen(int color) {
    return (color >> 8) & 0xFF;
  }

  int getBlue(int color) {
    return color & 0xFF;
  }

  int getColors(int r, int g, int b) {
    return (r << 16) | (g << 8) | b;
  }

  Pixel getPixelSafer(Image image, int x, int y) {
    if (x < 0 || x >= image.width || y < 0 || y >= image.height) {
      return Pixel.undefined;
    }

    return image.getPixelSafe(x, y);
  }
}

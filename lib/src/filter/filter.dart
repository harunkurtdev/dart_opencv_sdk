import 'package:dart_opencv_sdk/src/core/functions.dart';
import 'package:image/image.dart';

abstract class ImageFilter implements Image, CoreFunctions {
  Image applyFilter(Image image);
}

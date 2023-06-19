import 'package:dart_opencv_sdk/src/core/functions.dart';
import 'package:image/image.dart';

abstract class EdgeDetectorFilter implements Image, CoreFunctions {
  Image applyFilter(Image image);
}

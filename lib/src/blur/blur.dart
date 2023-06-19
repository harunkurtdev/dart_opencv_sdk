import 'package:dart_opencv_sdk/src/core/functions.dart';
import 'package:image/image.dart';

abstract class SmoothFilter implements Image {
  Image applyFilter(Image image);
}

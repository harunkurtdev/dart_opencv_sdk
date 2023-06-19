import 'package:dart_opencv_sdk/src/core/functions.dart';
import 'package:image/image.dart';

abstract class GeometricTransform implements Image {
  Image applyFilter(Image image);
}

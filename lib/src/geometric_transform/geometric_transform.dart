import 'package:dart_opencv_sdk/src/core/functions.dart';
import 'package:image/image.dart';

// https://docs.opencv.org/4.x/da/d6e/tutorial_py_geometric_transformations.html
abstract class GeometricTransform implements Image {
  Image applyFilter(Image image);
}

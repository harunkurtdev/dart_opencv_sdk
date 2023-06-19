import 'package:dart_opencv_sdk/src/geometric_transform/geometric_transform.dart';
import 'package:image/image.dart';
import 'package:image/src/image/image.dart';

class RotateImage implements GeometricTransform {
  final angle;

  RotateImage({this.angle});

  @override
  Image applyFilter(Image image) {
    return copyRotate(image, angle: angle);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

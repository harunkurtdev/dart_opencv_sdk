import 'dart:io';

import 'package:dart_opencv_sdk/src/geometric_transform/hough_circle.dart';
import 'package:dart_opencv_sdk/src/geometric_transform/hough_line.dart';
import 'package:image/image.dart';

void main(List<String> args) {
  Image image = decodeImage(File('balls2.png').readAsBytesSync())!;

  final houghLineTransform = HoughCircleTransform();
  final detect = houghLineTransform.markerHoughCircle(image,maxRadius: 0);

  File('balls_detect_houghcircle.jpg').writeAsBytesSync(encodeJpg(detect));
}

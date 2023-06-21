import 'dart:io';

import 'package:dart_opencv_sdk/src/geometric_transform/hough_circle.dart';
import 'package:dart_opencv_sdk/src/geometric_transform/hough_line.dart';
import 'package:image/image.dart';

void main(List<String> args) {
  Image image = decodeImage(File('line.png').readAsBytesSync())!;

  final houghLineTransform = HoughLineTransform();
  final detect = houghLineTransform.markerHoughLine(image);

  File('line_detect.jpg').writeAsBytesSync(encodeJpg(detect));
}

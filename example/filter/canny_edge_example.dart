import 'dart:io';

import 'package:dart_opencv_sdk/src/edge_detector/canny_edge.dart';
import 'package:dart_opencv_sdk/src/edge_detector/laplace.dart';
import 'package:dart_opencv_sdk/src/geometric_transform/rotate.dart';
import 'package:image/image.dart';

void main(List<String> args) async {
  Image image = decodeImage(File('balls2.png').readAsBytesSync())!;
  Image canny_image = CannyEdgeFilter(lowThreshold: 10,highThreshold: 65,sigma: 1).applyFilter(image);
  canny_image = RotateImage(angle: 25).applyFilter(canny_image);
  File('balls2_canny.jpg').writeAsBytesSync(encodeJpg(canny_image));
}

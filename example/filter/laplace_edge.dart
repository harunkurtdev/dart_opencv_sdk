import 'dart:io';

import 'package:dart_opencv_sdk/src/edge_detector/laplace.dart';
import 'package:dart_opencv_sdk/src/geometric_transform/rotate.dart';
import 'package:image/image.dart';

void main(List<String> args) async {
  Image image = decodeImage(File('ataturk.jpg').readAsBytesSync())!;
  Image canny_image = LaplaceFilter().applyFilter(image);
  canny_image = RotateImage(angle: 25).applyFilter(canny_image);
  File('atatruk_laplace_edge.jpg').writeAsBytesSync(encodeJpg(canny_image));
}

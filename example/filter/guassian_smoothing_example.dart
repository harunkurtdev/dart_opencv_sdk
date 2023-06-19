import 'dart:io';

import 'package:dart_opencv_sdk/src/edge_detector/canny_edge.dart';
import 'package:dart_opencv_sdk/src/smoothing/guassian.dart';
import 'package:image/image.dart';

void main(List<String> args) async {
  Image image = decodeImage(File('ataturk.jpg').readAsBytesSync())!;
  final canny_image = GaussianBlurFilter().applyFilter(image);
  File('atatruk_guassian.jpg').writeAsBytesSync(encodeJpg(canny_image));
}

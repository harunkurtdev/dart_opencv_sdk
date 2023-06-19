import 'dart:io';

import 'package:dart_opencv_sdk/src/edge_detector/laplace.dart';
import 'package:image/image.dart';

void main(List<String> args) async {
  Image image = decodeImage(File('ataturk.jpg').readAsBytesSync())!;
  final canny_image = LaplaceFilter().applyFilter(image);
  File('atatruk_laplace_edge.jpg').writeAsBytesSync(encodeJpg(canny_image));
}

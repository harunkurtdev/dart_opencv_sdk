import 'dart:io';

import 'package:dart_opencv_sdk/src/morphological/dilate.dart';
import 'package:dart_opencv_sdk/src/morphological/erode.dart';
import 'package:image/image.dart';

void main(List<String> args) {
  Image image = decodeImage(File('morphological.png').readAsBytesSync())!;

  final dilating = Eroding(iterations: 5);
  final dilatedImage = dilating.applyFilter(image);

  File('morphological_erode.png').writeAsBytesSync(encodeJpg(dilatedImage));
}

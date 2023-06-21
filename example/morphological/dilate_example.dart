import 'dart:io';

import 'package:dart_opencv_sdk/src/morphological/dilate.dart';
import 'package:image/image.dart';

void main(List<String> args) {
  Image image = decodeImage(File('morphological.png').readAsBytesSync())!;

  final dilating = Dilating(iterations: 3);
  final dilatedImage = dilating.applyFilter(image);

  File('morphological_dilate.png').writeAsBytesSync(encodeJpg(dilatedImage));
}

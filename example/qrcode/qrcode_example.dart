import 'dart:io';

import 'package:dart_opencv_sdk/src/qr_generator/qrcode_generator.dart';
import 'package:image/image.dart';

void main() {
  final qrCodeData = 'Hello, World!';

  final qrCodeGenerator = QRCodeGenerator();
  final qrCodeImage = qrCodeGenerator.generateQRCodeImage(qrCodeData,size:48);


  print(qrCodeImage);
  

  File('qr_code.jpg').writeAsBytesSync(encodeJpg(qrCodeImage));
}

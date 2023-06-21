import 'dart:io';

import 'package:dart_opencv_sdk/src/qr_generator/barcode_generator.dart';
import 'package:image/image.dart';

void main() {
  final barcodeGenerator = BarcodeGenerator();
  final barcodeData = '1234567890';

  // // Barkod resmini base64 formatında döndürür
  // final base64Barcode = barcodeGenerator.generateBarcode(barcodeData);
  // print('Base64 Barcode: $base64Barcode');

  // Barkod resmini dosyaya kaydeder
  final barcodeImage = barcodeGenerator.generateBarcodeImage(barcodeData,size: 256);
  final imagePath = 'barcode.png';
  File('barcode_code.jpg').writeAsBytesSync(encodeJpg(barcodeImage));
  print('Barcode saved to: $imagePath');
}

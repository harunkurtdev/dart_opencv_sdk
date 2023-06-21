import 'dart:convert';
import 'dart:math';
import 'package:image/image.dart';

class QRCodeGenerator {
  static const int quietZoneSize = 4;
  static const int moduleSize = 2;

  String generateQRCode(String data, {int size = 256}) {
    final qrCodeData = 'QR:$data';
    final qrCodeImage = Image(height: size, width: size);

    final qrCodeMatrix = _generateQRCodeMatrix(qrCodeData);
    _drawQRCode(qrCodeImage, qrCodeMatrix);

    final pngBytes = encodePng(qrCodeImage);
    final base64Image = base64Encode(pngBytes);

    return base64Image;
  }

  Image generateQRCodeImage(String data, {int size = 256}) {
    final qrCodeData = 'QR:$data';
    final qrCodeImage = Image(height: size, width: size);

    final qrCodeMatrix = _generateQRCodeMatrix(qrCodeData);
    _drawQRCode(qrCodeImage, qrCodeMatrix);

    return qrCodeImage;
  }

  List<List<bool>> _generateQRCodeMatrix(String qrCodeData) {
    final qrCodeMatrix = <List<bool>>[];

    final qrCodeSize = qrCodeData.length + quietZoneSize * 2;

    for (var i = 0; i < qrCodeSize; i++) {
      final row = List<bool>.filled(qrCodeSize, false);
      qrCodeMatrix.add(row);
    }

    _placeQRCodeData(qrCodeData, qrCodeMatrix);

    return qrCodeMatrix;
  }

  void _placeQRCodeData(String qrCodeData, List<List<bool>> qrCodeMatrix) {
    var rowIndex = quietZoneSize;
    var colIndex = quietZoneSize;

    for (var i = 0; i < qrCodeData.length; i++) {
      final bit = qrCodeData.codeUnitAt(i).toRadixString(2).padLeft(8, '0');

      for (var j = 0; j < bit.length; j++) {
        final value = bit[j] == '1';

        if (rowIndex < qrCodeMatrix.length &&
            colIndex < qrCodeMatrix[rowIndex].length) {
          qrCodeMatrix[rowIndex][colIndex] = value;
        }

        colIndex++;

        if (colIndex >= qrCodeMatrix[rowIndex].length) {
          rowIndex++;
          colIndex = quietZoneSize;
        }
      }
    }
  }

  // void _drawQRCode(Image qrCodeImage, List<List<bool>> qrCodeMatrix) {
  //   final qrCodeSize = qrCodeMatrix.length;
  //   final imageSize = qrCodeSize * moduleSize;

  //   final white = ColorFloat64.rgb(255, 255, 255);
  //   final black = ColorFloat64.rgb(0, 0, 0);

  //   qrCodeImage.backgroundColor = white;

  //   for (var y = 0; y < imageSize; y++) {
  //     for (var x = 0; x < imageSize; x++) {
  //       final moduleX = (x / moduleSize).floor();
  //       final moduleY = (y / moduleSize).floor();

  //       final value = qrCodeMatrix[moduleY][moduleX];

  //       final pixelColor = value ? black : white;
  //       qrCodeImage.setPixel(x, y, pixelColor);
  //     }
  //   }
  // }

  void _drawQRCode(Image qrCodeImage, List<List<bool>> qrCodeMatrix) {
    final qrCodeSize = qrCodeMatrix.length;
    final imageSize = qrCodeSize * moduleSize;

    final white = ColorFloat64.rgb(255, 255, 255);
    final black = ColorFloat64.rgb(0, 0, 0);

    qrCodeImage.backgroundColor = white;

    for (var y = 0; y < qrCodeSize; y++) {
      for (var x = 0; x < qrCodeSize; x++) {
        for (var my = 0; my < moduleSize; my++) {
          for (var mx = 0; mx < moduleSize; mx++) {
            final moduleX = x * moduleSize + mx;
            final moduleY = y * moduleSize + my;

            final value = qrCodeMatrix[y][x];

            final pixelColor = value ? black : white;
            qrCodeImage.setPixel(moduleX, moduleY, pixelColor);
          }
        }
      }
    }
  }
}

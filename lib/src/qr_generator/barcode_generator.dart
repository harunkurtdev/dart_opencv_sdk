import 'dart:convert';
import 'dart:math';
import 'package:image/image.dart';

class BarcodeGenerator {
  static const int quietZoneSize = 10;
  static const int moduleSize = 2;

  Image generateBarcodeImage(String data, {int size = 256}) {
    final barcodeData = 'BC:$data';
    final barcodeMatrix = _generateBarcodeMatrix(barcodeData);
    final barcodeImage = _drawBarcode(barcodeMatrix, size);
    return barcodeImage;
  }

  List<List<bool>> _generateBarcodeMatrix(String barcodeData) {
    final barcodeMatrix = <List<bool>>[];
    final barcodeSize = barcodeData.length + quietZoneSize * 2;

    for (var i = 0; i < barcodeSize; i++) {
      final row = List<bool>.filled(barcodeSize, false);
      barcodeMatrix.add(row);
    }

    _placeBarcodeData(barcodeData, barcodeMatrix);

    return barcodeMatrix;
  }

  void _placeBarcodeData(String barcodeData, List<List<bool>> barcodeMatrix) {
    var rowIndex = quietZoneSize;
    var colIndex = quietZoneSize;

    for (var i = 0; i < barcodeData.length; i++) {
      final bit = barcodeData.codeUnitAt(i).toRadixString(2).padLeft(8, '0');

      for (var j = 0; j < bit.length; j++) {
        final value = bit[j] == '1';

        if (rowIndex < barcodeMatrix.length &&
            colIndex < barcodeMatrix[rowIndex].length) {
          barcodeMatrix[rowIndex][colIndex] = value;
        }

        colIndex++;

        if (colIndex >= barcodeMatrix[rowIndex].length) {
          rowIndex++;
          colIndex = quietZoneSize;
        }
      }
    }
  }

  Image _drawBarcode(List<List<bool>> barcodeMatrix, int size) {
    final barcodeSize = barcodeMatrix.length;
    final imageSize = barcodeSize * moduleSize;

    final white = ColorFloat64.rgb(255, 255, 255);
    final black = ColorFloat64.rgb(0, 0, 0);

    final image = Image(height: imageSize, width: imageSize);

    for (var y = 0; y < imageSize; y++) {
      for (var x = 0; x < imageSize; x++) {
        final moduleX = (x / moduleSize).floor();
        final moduleY = (y / moduleSize).floor();

        final value = barcodeMatrix[moduleY][moduleX];

        final pixelColor = value ? black : white;
        image.setPixel(x, y, pixelColor);
      }
    }

    return image;
  }
}

import 'dart:math';
import 'package:image/image.dart';
import '../core/functions.dart';

class PerspectiveTransformation extends CoreFunctions {

  Image applyTransformation(Image image, List<Point> sourcePoints,
      List<Point> destinationPoints) {
    final homographyMatrix = _calculateHomographyMatrix(
        sourcePoints[0], sourcePoints[1], sourcePoints[2], sourcePoints[3],
        destinationPoints[0], destinationPoints[1], destinationPoints[2],
        destinationPoints[3]);

    final transformedImage = Image(width: image.width, height: image.height);

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final transformedPoint = _applyHomographyMatrix(homographyMatrix, x, y);

        if (_isInsideImage(
            transformedImage, transformedPoint.x.toInt(), transformedPoint.y.toInt())) {
          // final pixel = _getPixelBilinear(
          //     image, transformedPoint.x.toDouble(), transformedPoint.y.toDouble());
          // transformedImage.setPixel(x, y, pixel as Color);
        }
      }
    }

    return transformedImage;
  }

  Matrix _calculateHomographyMatrix(
      Point src1, Point src2, Point src3, Point src4,
      Point dst1, Point dst2, Point dst3, Point dst4) {
    final sourcePoints = [
      Vector([src1.x.toDouble(), src1.y.toDouble(), 1]),
      Vector([src2.x.toDouble(), src2.y.toDouble(), 1]),
      Vector([src3.x.toDouble(), src3.y.toDouble(), 1]),
      Vector([src4.x.toDouble(), src4.y.toDouble(), 1]),
    ];

    final destinationPoints = [
      Vector([dst1.x.toDouble(), dst1.y.toDouble(), 1]),
      Vector([dst2.x.toDouble(), dst2.y.toDouble(), 1]),
      Vector([dst3.x.toDouble(), dst3.y.toDouble(), 1]),
      Vector([dst4.x.toDouble(), dst4.y.toDouble(), 1]),
    ];

    final transformationMatrix = Matrix.fromRows(
        sourcePoints[0], sourcePoints[1], sourcePoints[2]);

    final inverseTransformationMatrix =
        transformationMatrix.inverse() as Matrix;

    final homographyMatrix = inverseTransformationMatrix *
        Matrix.fromColumns(
          destinationPoints[0],
          destinationPoints[1],
          destinationPoints[2],
        );

    return homographyMatrix;
  }

  Point _applyHomographyMatrix(Matrix matrix, int x, int y) {
    final point = Vector([x.toDouble(), y.toDouble(), 1]);
    final transformedPoint = matrix.multiplyVector(point);
    return Point(transformedPoint[0] ~/ transformedPoint[2], transformedPoint[1] ~/ transformedPoint[2]);
  }

  bool _isInsideImage(Image image, int x, int y) {
    return x >= 0 && x < image.width && y >= 0 && y < image.height;
  }

//   int _getPixelBilinear(Image image, double x, double y) { //FIXME hata!
//   final x1 = x.floor();
//   final y1 = y.floor();
//   final x2 = x1 + 1;
//   final y2 = y1 + 1;

//   final q11 = _getPixel(image, x1, y1);
//   final q21 = _getPixel(image, x2, y1);
//   final q12 = _getPixel(image, x1, y2);
//   final q22 = _getPixel(image, x2, y2);

//   final valueR = _bilinearInterpolation(
//       q11.red, q21.red, q12.red, q22.red, x, y);
//   final valueG = _bilinearInterpolation(
//       q11.green, q21.green, q12.green, q22.green, x, y);
//   final valueB = _bilinearInterpolation(
//       q11.blue, q21.blue, q12.blue, q22.blue, x, y);

//   return Color.rgb(
//     valueR.toInt(),
//     valueG.toInt(),
//     valueB.toInt(),
//   );
// }

// Color _getPixel(Image image, int x, int y) {
//   if (_isInsideImage(image, x, y)) {
//     final colorValue = image.getPixelSafe(x, y);
//     return Color.rgb(getRed(colorValue as int), getGreen(colorValue as int), getBlue(colorValue as int));
//   } else {
//     return Color.rgb(0, 0, 0);
//   }
// }


  double _bilinearInterpolation(
      int q11, int q21, int q12, int q22, double x, double y) {
    final value1 = q11 * (1 - (x % 1)) + q21 * (x % 1);
    final value2 = q12 * (1 - (x % 1)) + q22 * (x % 1);
    return value1 * (1 - (y % 1)) + value2 * (y % 1);
  }
}

class Matrix {
  final List<Vector> _rows;

  Matrix(this._rows);

  int get rowCount => _rows.length;

  int get columnCount => _rows.isNotEmpty ? _rows[0].dimension : 0;

  Vector operator [](int rowIndex) => _rows[rowIndex];

  Matrix operator *(Matrix other) {
    if (columnCount != other.rowCount) {
      throw Exception('Matrix dimensions are not compatible for multiplication!');
    }

    final result = List<Vector>.generate(rowCount, (i) => Vector.zero(columnCount));

    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < other.columnCount; j++) {
        var sum = 0.0;
        for (var k = 0; k < columnCount; k++) {
          sum += this[i][k] * other[k][j];
        }
        result[i][j] = sum;
      }
    }

    return Matrix(result);
  }

  Vector multiplyVector(Vector vector) {
    if (columnCount != vector.dimension) {
      throw Exception('Matrix and vector dimensions are not compatible for multiplication!');
    }

    final result = List<double>.generate(rowCount, (i) {
      var sum = 0.0;
      for (var j = 0; j < columnCount; j++) {
        sum += this[i][j] * vector[j];
      }
      return sum;
    });

    return Vector(result);
  }

  Matrix inverse() {
    final det = determinant();

    if (det == 0) {
      throw Exception('Matrix is not invertible');
    }

    final invDet = 1.0 / det;

    final m11 = _rows[0][0];
    final m12 = _rows[0][1];
    final m13 = _rows[0][2];

    final m21 = _rows[1][0];
    final m22 = _rows[1][1];
    final m23 = _rows[1][2];

    final m31 = _rows[2][0];
    final m32 = _rows[2][1];
    final m33 = _rows[2][2];

    final invDetM11 = (m22 * m33 - m23 * m32) * invDet;
    final invDetM12 = (m13 * m32 - m12 * m33) * invDet;
    final invDetM13 = (m12 * m23 - m13 * m22) * invDet;

    final invDetM21 = (m23 * m31 - m21 * m33) * invDet;
    final invDetM22 = (m11 * m33 - m13 * m31) * invDet;
    final invDetM23 = (m13 * m21 - m11 * m23) * invDet;

    final invDetM31 = (m21 * m32 - m22 * m31) * invDet;
    final invDetM32 = (m12 * m31 - m11 * m32) * invDet;
    final invDetM33 = (m11 * m22 - m12 * m21) * invDet;

    return Matrix.fromRows(
      Vector([invDetM11, invDetM12, invDetM13]),
      Vector([invDetM21, invDetM22, invDetM23]),
      Vector([invDetM31, invDetM32, invDetM33]),
    );
  }

  double determinant() {
    final m11 = _rows[0][0];
    final m12 = _rows[0][1];
    final m13 = _rows[0][2];

    final m21 = _rows[1][0];
    final m22 = _rows[1][1];
    final m23 = _rows[1][2];

    final m31 = _rows[2][0];
    final m32 = _rows[2][1];
    final m33 = _rows[2][2];

    return m11 * (m22 * m33 - m23 * m32) -
        m12 * (m21 * m33 - m23 * m31) +
        m13 * (m21 * m32 - m22 * m31);
  }

  static Matrix fromRows(Vector row1, Vector row2, Vector row3) {
    return Matrix([row1, row2, row3]);
  }

  static Matrix fromColumns(Vector column1, Vector column2, Vector column3) {
    return Matrix([
      Vector([column1[0], column2[0], column3[0]]),
      Vector([column1[1], column2[1], column3[1]]),
      Vector([column1[2], column2[2], column3[2]]),
    ]);
  }
}

class Vector {
  final List<double> _values;

  Vector(this._values);

  int get dimension => _values.length;

  double operator [](int index) => _values[index];

  void operator []=(int index, double value) {
    _values[index] = value;
  }

  Vector operator *(Vector other) {
    if (other.dimension != dimension) {
      throw Exception('Vectors must have the same dimension!');
    }

    final result = List<double>.generate(dimension, (i) => this[i] * other[i]);
    return Vector(result);
  }

  Vector operator +(Vector other) {
    if (other.dimension != dimension) {
      throw Exception('Vectors must have the same dimension!');
    }

    final result = List<double>.generate(dimension, (i) => this[i] + other[i]);
    return Vector(result);
  }

  double norm() {
    return sqrt(_values.map((x) => x * x).reduce((value, element) => value + element));
  }

  @override
  String toString() {
    return _values.toString();
  }

  static Vector zero(int dimension) {
    return Vector(List.filled(dimension, 0.0));
  }
}

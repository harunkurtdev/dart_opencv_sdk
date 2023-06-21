// import 'package:image/image.dart';
// import 'dart:math';


// // TODO 
// class PerspectiveTransformation {
//   Image applyTransformation(Image image, List<Point<int>> sourcePoints,
//       List<Point<int>> destinationPoints) {
//     final homographyMatrix = _calculateHomographyMatrix(
//         sourcePoints[0], sourcePoints[1], sourcePoints[2], sourcePoints[3],
//         destinationPoints[0], destinationPoints[1], destinationPoints[2],
//         destinationPoints[3]);

//     final transformedImage = Image(image.width, image.height);

//     for (var y = 0; y < image.height; y++) {
//       for (var x = 0; x < image.width; x++) {
//         final transformedPoint = _applyHomographyMatrix(homographyMatrix, x, y);

//         if (_isInsideImage(transformedImage, transformedPoint.x, transformedPoint.y)) {
//           final pixel = _getPixelBilinear(image, transformedPoint.x, transformedPoint.y);
//           transformedImage.setPixel(x, y, pixel);
//         }
//       }
//     }

//     return transformedImage;
//   }

//   Matrix3 _calculateHomographyMatrix(
//       Point<int> src1, Point<int> src2, Point<int> src3, Point<int> src4,
//       Point<int> dst1, Point<int> dst2, Point<int> dst3, Point<int> dst4) {
//     final sourcePoints = [
//       Vector3(src1.x.toDouble(), src1.y.toDouble(), 1),
//       Vector3(src2.x.toDouble(), src2.y.toDouble(), 1),
//       Vector3(src3.x.toDouble(), src3.y.toDouble(), 1),
//       Vector3(src4.x.toDouble(), src4.y.toDouble(), 1),
//     ];

//     final destinationPoints = [
//       Vector3(dst1.x.toDouble(), dst1.y.toDouble(), 1),
//       Vector3(dst2.x.toDouble(), dst2.y.toDouble(), 1),
//       Vector3(dst3.x.toDouble(), dst3.y.toDouble(), 1),
//       Vector3(dst4.x.toDouble(), dst4.y.toDouble(), 1),
//     ];

//     final transformationMatrix = Matrix3.fromRows(
//         sourcePoints[0], sourcePoints[1], sourcePoints[2]);

//     final inverseTransformationMatrix =
//         transformationMatrix.inverse() as Matrix3;

//     final homographyMatrix = Matrix3.fromRows(
//       (inverseTransformationMatrix * destinationPoints[0]).normalized(),
//       (inverseTransformationMatrix * destinationPoints[1]).normalized(),
//       (inverseTransformationMatrix * destinationPoints[2]).normalized(),
//     );

//     return homographyMatrix;
//   }

//   Point<int> _applyHomographyMatrix(Matrix3 matrix, int x, int y) {
//     final point = matrix * Vector3(x.toDouble(), y.toDouble(), 1);
//     return Point(point.x ~/ point.z, point.y ~/ point.z);
//   }

//   bool _isInsideImage(Image image, int x, int y) {
//     return x >= 0 && x < image.width && y >= 0 && y < image.height;
//   }

//   int _getPixelBilinear(Image image, double x, double y) {
//     final x1 = x.floor();
//     final y1 = y.floor();
//     final x2 = x1 + 1;
//     final y2 = y1 + 1;

//     final q11 = _getPixel(image, x1, y1);
//     final q21 = _getPixel(image, x2, y1);
//     final q12 = _getPixel(image, x1, y2);
//     final q22 = _getPixel(image, x2, y2);

//     final valueR = _bilinearInterpolation(q11.red, q21.red, q12.red, q22.red, x, y);
//     final valueG = _bilinearInterpolation(q11.green, q21.green, q12.green, q22.green, x, y);
//     final valueB = _bilinearInterpolation(q11.blue, q21.blue, q12.blue, q22.blue, x, y);

//     return Color(valueR.toInt(), valueG.toInt(), valueB.toInt());
//   }

//   Color _getPixel(Image image, int x, int y) {
//     if (_isInsideImage(image, x, y)) {
//       return Color(image.getPixel(x, y));
//     } else {
//       return Color(0, 0, 0);
//     }
//   }

//   double _bilinearInterpolation(
//       int q11, int q21, int q12, int q22, double x, double y) {
//     final value1 = q11 * (1 - (x % 1)) + q21 * (x % 1);
//     final value2 = q12 * (1 - (x % 1)) + q22 * (x % 1);
//     return value1 * (1 - (y % 1)) + value2 * (y % 1);
//   }
// }

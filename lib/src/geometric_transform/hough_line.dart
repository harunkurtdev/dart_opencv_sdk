import 'package:dart_opencv_sdk/src/edge_detector/canny_edge.dart';
import 'package:dart_opencv_sdk/src/filter/grayscale.dart';
import 'package:image/image.dart';
import 'dart:math';

class HoughLineTransform {
  List<Line> detectLines(Image image) {
    final edges = applyCannyEdgeDetection(image);
    final lines = performHoughTransform(edges);
    return lines;
  }

  Image applyCannyEdgeDetection(Image image) {
    final cannyEdgeFilter = CannyEdgeFilter();
    return cannyEdgeFilter.applyFilter(image);
  }

  List<Line> performHoughTransform(Image image) {
    final lines = <Line>[];

    final width = image.width;
    final height = image.height;
    final diagonal = sqrt(width * width + height * height);

    final accumulator = <double, List<int>>{};
    final threshold = 100;

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final pixel = image.getPixel(x, y);
        final pixelValue = pixel.r;

        if (pixelValue == 255) {
          for (var theta = 0; theta < 180; theta++) {
            final angle = theta * (pi / 180);
            final rho = x * cos(angle) + y * sin(angle);

            if (accumulator.containsKey(rho)) {
              accumulator[rho]!.add(theta);
            } else {
              accumulator[rho] = [theta];
            }
          }
        }
      }
    }

    accumulator.forEach((rho, thetaList) {
      if (thetaList.length >= threshold) {
        final averageTheta =
            thetaList.reduce((a, b) => a + b) / thetaList.length;
        final angle = averageTheta * (pi / 180);
        final cosTheta = cos(angle);
        final sinTheta = sin(angle);
        final x0 = rho * cosTheta;
        final y0 = rho * sinTheta;
        final x1 = (x0 + diagonal * (-sinTheta)).round();
        final y1 = (y0 + diagonal * cosTheta).round();
        final x2 = (x0 - diagonal * (-sinTheta)).round();
        final y2 = (y0 - diagonal * cosTheta).round();

        final line = Line(Point(x1, y1), Point(x2, y2));
        lines.add(line);
      }
    });

    return lines;
  }

  Image markerHoughLine(Image image) {
    Image marker = Image(width: image.width, height: image.height);
    final lines = detectLines(image);
    for (var line in lines) {
      final startPoint = line.startPoint;
      final endPoint = line.endPoint;

      // Çizginin tüm piksellerini işaretleme
      for (var x = startPoint.x; x <= endPoint.x; x++) {
        for (var y = startPoint.y; y <= endPoint.y; y++) {
          image.setPixel(
              x, y, ColorFloat64.rgb(255, 0, 0)); // Kırmızı renkte işaretleme
        }
      }
    }
    return marker;
  }
}

class Line {
  final Point startPoint;
  final Point endPoint;

  Line(this.startPoint, this.endPoint);
}

class Point {
  final int x;
  final int y;

  Point(this.x, this.y);
}

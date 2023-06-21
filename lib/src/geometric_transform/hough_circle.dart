import 'package:dart_opencv_sdk/src/edge_detector/canny_edge.dart';
import 'package:dart_opencv_sdk/src/filter/grayscale.dart';
import 'package:image/image.dart';
import 'dart:math';

class HoughCircleTransform {
  List<Circle> detectCircles(Image image,
      {int minRadius = 0, int maxRadius = 0}) {
    final edges = applyCannyEdgeDetection(image);
    final circles = performHoughCircleTransform(edges, minRadius, maxRadius);
    return circles;
  }

  Image applyCannyEdgeDetection(Image image) {
    final cannyEdgeFilter = CannyEdgeFilter();
    return cannyEdgeFilter.applyFilter(image);
  }

  List<Circle> performHoughCircleTransform(
      Image image, int minRadius, int maxRadius) {
    final circles = <Circle>[];

    final width = image.width;
    final height = image.height;

    for (var radius = minRadius; radius <= maxRadius; radius++) {
      final accumulator = <int, List<Point>>{};
      final threshold = 100;

      for (var y = 0; y < height; y++) {
        for (var x = 0; x < width; x++) {
          final pixel = image.getPixel(x, y);
          final pixelValue = pixel.r;

          if (pixelValue == 255) {
            for (var theta = 0; theta < 360; theta++) {
              final angle = theta * (pi / 180);
              final centerX = x - radius * cos(angle);
              final centerY = y - radius * sin(angle);
              final center = Point(centerX.round(), centerY.round());

              if (accumulator.containsKey(radius)) {
                accumulator[radius]!.add(center);
              } else {
                accumulator[radius] = [center];
              }
            }
          }
        }
      }

      accumulator.forEach((radius, centers) {
        if (centers.length >= threshold) {
          circles.add(Circle(centers[0], radius));
        }
      });
    }

    return circles;
  }

  Image markerHoughCircle(Image image, {int minRadius = 0, int maxRadius = 0}) {
    Image marker = Image(width: image.width, height: image.height);
    final circles =
        detectCircles(image, minRadius: minRadius, maxRadius: maxRadius);
    for (var circle in circles) {
      final center = circle.center;
      final radius = circle.radius;

      // Çemberin tüm piksellerini işaretleme
      for (var theta = 0; theta < 360; theta++) {
        final angle = theta * (pi / 180);
        final x = center.x + radius * cos(angle);
        final y = center.y + radius * sin(angle);
        marker.setPixel(x.round(), y.round(),
            ColorFloat64.rgb(255, 0, 0)); // Kırmızı renkte işaretleme
      }
    }
    return marker;
  }
}

class Circle {
  final Point center;
  final int radius;

  Circle(this.center, this.radius);
}

class Point {
  final int x;
  final int y;

  Point(this.x, this.y);
}

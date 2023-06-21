import 'dart:io';

import 'package:dart_opencv_sdk/src/edge_detector/canny_edge.dart';
import 'package:dart_opencv_sdk/src/edge_detector/laplace.dart';
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
    final cannyEdgeFilter =
        CannyEdgeFilter(lowThreshold: 10, highThreshold: 65, sigma: 0.75);
    File('balls_detect_houghcircle1.jpg')
        .writeAsBytesSync(encodeJpg(cannyEdgeFilter.applyFilter(image)));

    return cannyEdgeFilter.applyFilter(image);
  }

  // TODO: bu sınıfa ait circle detect etme kısmı başarısız
  List<Circle> performHoughCircleTransform(
      Image image, int minRadius, int maxRadius,
      {int frameSize = 100}) {
    final circles = <Circle>[];

    final width = image.width;
    final height = image.height;

    final expandedWidth = width + frameSize * 2;
    final expandedHeight = height + frameSize * 2;

    for (var radius = minRadius; radius <= maxRadius; radius++) {
      final accumulator = <int, List<Point>>{};
      final threshold = 100;

      for (var y = 0; y < height; y++) {
        for (var x = 0; x < width; x++) {
          final pixel = image.getPixel(x, y);
          final pixelValue = pixel.r;

          if (pixelValue > 0) {
            for (var theta = 0; theta < 360; theta++) {
              final angle = theta * (pi / 180);
              final centerX = x + radius * cos(angle);
              final centerY = y + radius * sin(angle);
              final center = Point(centerX.round(), centerY.round());

              if (accumulator.containsKey(radius)) {
                if (!accumulator[radius]!.contains(center)) {
                  accumulator[radius]!.add(center);
                }
              } else {
                accumulator[radius] = [center];
              }
            }
          }
        }
      }

      accumulator.forEach((radius, centers) {
        if (centers.length >= threshold) {
          for (var center in centers) {
            circles.add(Circle(center, radius));
          }
        }
      });
    }

    return circles;
  }

  Image markerHoughCircle(Image image, {int minRadius = 0, int maxRadius = 0}) {
    final circles =
        detectCircles(image, minRadius: minRadius, maxRadius: maxRadius);

    Image marker = Image(width: image.width, height: image.height);

    for (var circle in circles) {
      final center = circle.center;
      final radius = circle.radius;

      for (var theta = 0; theta < 360; theta++) {
        final angle = theta * (pi / 180);
        final x = center.x + radius * cos(angle);
        final y = center.y + radius * sin(angle);

        // if (x >= 0 && x < image.width && y >= 0 && y < image.height) {
        //   image.setPixel(x.round(), y.round(), ColorFloat64.rgb(255, 0, 0));
        // }

        image = drawCircle(image,
            x: center.x,
            y: center.y,
            radius: radius,
            color: ColorFloat64.rgb(255, 0, 0));
      }
    }

    return image;
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

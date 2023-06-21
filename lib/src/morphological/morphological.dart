import 'package:image/image.dart';

import 'dilate.dart';
import 'erode.dart';

abstract class MorpHological implements Image {
  Image applyFilter(Image image);
}

class OpeningFilter implements MorpHological {
  final int iterations;

  OpeningFilter({this.iterations = 1});

  @override
  Image applyFilter(Image image) {
    final erodedImage = Eroding(iterations: iterations).applyFilter(image);
    final openedImage =
        Dilating(iterations: iterations).applyFilter(erodedImage);

    return openedImage;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MorphologicalGradientFilter implements MorpHological {
  final int iterations;

  MorphologicalGradientFilter({this.iterations = 1});

  @override
  Image applyFilter(Image image) {
    final dilatedImage = Dilating(iterations: iterations).applyFilter(image);
    final erodedImage = Eroding(iterations: iterations).applyFilter(image);
    final morphologicalGradient = Image.from(dilatedImage);
    Pixel pixel = Pixel.undefined;

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final dilatedPixel = dilatedImage.getPixel(x, y);
        final erodedPixel = erodedImage.getPixel(x, y);

        pixel.r = dilatedPixel.r - erodedPixel.r;
        pixel.g = dilatedPixel.g - erodedPixel.g;
        pixel.b = dilatedPixel.b - erodedPixel.b;

        final gradientPixel = pixel;
        morphologicalGradient.setPixel(x, y, gradientPixel);
      }
    }

    return morphologicalGradient;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ClosingFilter implements MorpHological {
  final int iterations;

  ClosingFilter({this.iterations = 1});

  @override
  Image applyFilter(Image image) {
    final dilatedImage = Dilating(iterations: iterations).applyFilter(image);
    final closedImage =
        Eroding(iterations: iterations).applyFilter(dilatedImage);

    return closedImage;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class TopHatFilter implements MorpHological {
  final int iterations;

  TopHatFilter({this.iterations = 1});

  // TODO: "bırada TopHatFilter formülü uygulammalı, resim den değilde pixelden çıkarılmalı"
  @override
  Image applyFilter(Image image) {
    final openedImage =
        OpeningFilter(iterations: iterations).applyFilter(image);
    final topHatImage = Image(width: image.width, height: image.height);
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final originalPixel = image.getPixel(x, y);
        final openedPixel = openedImage.getPixel(x, y);

        final diffR = originalPixel.r - openedPixel.r;
        final diffG = originalPixel.g - openedPixel.g;
        final diffB = originalPixel.b - openedPixel.b;

        final topHatPixel = ColorFloat64.rgb(diffR, diffG, diffB);
        topHatImage.setPixel(x, y, topHatPixel);
      }
    }

    return topHatImage;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class BlackHatFilter implements MorpHological {
  final int iterations;

  BlackHatFilter({this.iterations = 1});

  // TODO: "bırada blackhat formülü uygulammalı, resim den değilde pixelden çıkarılmalı"
  @override
  Image applyFilter(Image image) {
    final closedImage =
        ClosingFilter(iterations: iterations).applyFilter(image);

    final blackHatImage = Image(width: image.width, height: image.height);
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final originalPixel = image.getPixel(x, y);
        final openedPixel = closedImage.getPixel(x, y);

        final diffR = openedPixel.r - originalPixel.r;
        final diffG = openedPixel.g - originalPixel.g;
        final diffB = openedPixel.b - originalPixel.b;

        final topHatPixel = ColorFloat64.rgb(diffR, diffG, diffB);
        blackHatImage.setPixel(x, y, topHatPixel);
      }
    }

    return blackHatImage;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

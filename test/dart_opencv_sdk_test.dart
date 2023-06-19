import 'package:dart_opencv_sdk/dart_opencv_sdk.dart';
import 'package:test/test.dart';

class ClassName {
  ClassName name(params) {
    return this;
  }
}

void main() {
  ClassName().name("aaa").name("Hello").name("aa");

  group('A group of tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {});
  });
}

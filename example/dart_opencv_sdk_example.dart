import 'package:dart_opencv_sdk/dart_opencv_sdk.dart';
import 'package:image/image.dart' as img;

void main() async {
  await (img.Command()
        // Read a WebP image from a file.
        ..decodeWebPFile('test.webp')
        // Resize the image so its width is 120 and height maintains aspect
        // ratio.
        ..copyResize(width: 1200)
        // ..grayscale()
        ..drawCircle(
            x: 20, y: 50, radius: 50, color: img.ColorFloat16.rgb(255, 0, 0))
        // Save the image to a PNG file.
        ..writeToFile('thumbnail_normalize.png'))
      // Execute the image commands in an isolate thread
      .executeThread();
}

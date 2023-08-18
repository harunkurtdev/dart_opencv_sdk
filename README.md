# OpenCV SDK for Dart

The OpenCV SDK for Dart is a powerful and versatile computer vision library that allows developers to integrate OpenCV functionality into their Dart applications. This SDK provides a bridge between Dart and the OpenCV library, enabling you to leverage advanced computer vision techniques seamlessly.

## Features

- **High-Performance:** Benefit from the high-performance capabilities of the OpenCV library directly from your Dart applications.

- **Wide Range of Algorithms:** Access a comprehensive collection of image processing and computer vision algorithms, including filtering, feature detection, object tracking, and more.

- **Easy Integration:** The SDK provides a user-friendly interface to easily integrate OpenCV functionalities into your Dart projects.


## TODO

TODO:

- [ ] Image Reading and Writing:
  - [X] Read image: `imread()`
  - [X] Write image: `imwrite()`

- [ ] Image Properties:
  - [X] Get image size: `size()`
  - [ ] Determine image type: `type()`
  - [ ] Access and modify pixel values on the image: `at()`, `set()`

- [ ] Morphological Operation:
  - [X] Eroding ![](./example/morphological/morphological_erode.png)
  - [X] Dilate ![](./example/morphological/morphological_dilate.png)

- [ ] Color Conversions:
  - [X] Convert color spaces: `cvtColor()` for grayscale
  - [ ] Define constants for color space conversions: `COLOR_*`

- [ ] Filtering and Edge Detection:
  - [X] Gaussian blur: `GaussianBlur()`
  - [X] Average blur: `Average()`
  - [X] Bileteral blur: `Bileteral()`
  - [X] Average blur: `Average()`
  - [X] Median blur: `medianBlur()`

- [ ] Edge Detection:
  - [X] Edge detection: `Canny()`
  - [X]  Laplace: `Laplace()`
  - [X]  Sobel: `Sobel()`

- [ ] Geometric Transformations:
  - [ ] Perspective transformation: `warpPerspective()`
  - [X] Scaling: `resize()`
  - [X] Rotation: `rotate()`

- [X] Hough Detection Transformations:
  - [X] Hough Circle:
  - [X] Hough Line: 

- [ ] Template Matching:
  - [ ] Template matching operation: `matchTemplate()`

- [ ] Contour Detection:
  - [ ] Contour detection: `findContours()`
  - [ ] Compute contour properties: `contourArea()`, `arcLength()`, `boundingRect()`

- [ ] Object Detection:
  - [ ] Face detection: `CascadeClassifier()`
  - [ ] Object detection: `detectMultiScale()`

- [ ] Computational Operations:
  - [ ] Mathematical operations: `add()`, `subtract()`, `multiply()`, `divide()`
  - [ ] Histogram calculation: `calcHist()`

- [ ] Image Processing Helpers:
  - [ ] Bitwise masking operations: `bitwise_and()`, `bitwise_or()`, `bitwise_not()`
  - [ ] Splitting and merging images: `split()`, `merge()`
  - [ ] Defining Regions of Interest (ROI): `Rect()`

- [ ] Graphical User Interface (GUI) Helpers:
  - [ ] Display image on the screen: `imshow()`
  - [ ] Detect keyboard or mouse interactions: `waitKey()`


## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

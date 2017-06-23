# tessellationapp

Tessellation

## Getting Started

For help getting started with Flutter, view our online
[documentation](http://flutter.io/).

## Development Notes

### Graphics
Use transformPoint in MatrixUtils to transform points.
Matrix4 not the same as the matrix4 in vector_math!
add vector_math: any to pubspec.yaml
import 'package:vector_math/vector_math_64.dart' show Vector3;
init matrix with identity matrix! otherwise 0 scale!
rotateZ is 2d rotate on flat paper
addpath and extended path don't join the lines

### Read and Parse files
* https://flutter.io/reading-writing-files/#example-of-reading-and-writing-to-a-file
* https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/gallery/example_code_parser.dart

## Files and Directories

* https://flutter.io/reading-writing-files/#example-of-reading-and-writing-to-a-file
* https://github.com/flutter/flutter/blob/master/dev/tools/dartdoc.dart

## Futures

* https://www.dartlang.org/tutorials/language/futures

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

## Icons

Scale icons with convert inkscape script

inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=Icon-App-20x20@1x.png -w20 -h20
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=Icon-App-20x20@2x.png -w40 -h40
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=Icon-App-20x20@3x.png -w60 -h60
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=Icon-App-29x29@1x.png -w29 -h29
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=Icon-App-29x29@2x.png -w58 -h58
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=Icon-App-29x29@3x.png -w87 -h87
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=Icon-App-40x40@1x.png -w40 -h40
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=Icon-App-40x40@2x.png -w80 -h80
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=Icon-App-40x40@3x.png -w120 -h120
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=Icon-App-60x60@2x.png -w120 -h120
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=Icon-App-60x60@3x.png -w180 -h180
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=Icon-App-76x76@1x.png -w76 -h76
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=Icon-App-76x76@2x.png -w152 -h152
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=Icon-App-83.5x83.5@2x.png -w167 -h167

Only convert the image part not the whole page with -a 0:-6.933:320:313.067

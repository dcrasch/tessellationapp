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
write assetfigure?? extended from assetbundle,(like image bundle)>
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
Run build parts in de pubspec.yml
$ flutter packages pub build

## Colorwheel

https://github.com/chiralcode/Android-Color-Picker/blob/master/src/com/chiralcode/colorpicker/ColorPicker.java

SweepGradient sweepGradient = new SweepGradient(width / 2, height / 2, colors, null);
RadialGradient radialGradient = new RadialGradient(width / 2, height / 2, colorWheelRadius, 0xFFFFFFFF, 0x00FFFFFF, TileMode.CLAMP);
ComposeShader composeShader = new ComposeShader(sweepGradient, radialGradient, PorterDuff.Mode.SRC_OVER);
 colorWheelPaint.setShader(composeShader);
canvas.drawCircle(width / 2, height / 2, colorWheelRadius, colorWheelPaint);
file:///Users/david/flutter/dev/docs/doc/flutter/dart-ui/Gradient-class.html
flutter/packages/flutter/lib/src/painting/box_painter.dart
      gradient: new ui.Gradient.sweep(
                    new Offset(100.0,100.0),
                    <Color>[Colors.red,Colors.blue]

aanpassingen aan painting.dart
    ninja -C out/ios_debug_sim_unopt
??  flutter update-packages --upgrade --local-engine=ios_debug_sim_unopt
  
  FLUTTER_ENGINE=/Users/david/src/engine/src/
  flutter run --local-engine=ios_debug_sim_unopt -d 7493B601-8A6F-4F59-808F-A4AA5AAA1BB9
  
PictureRecorder 
 canvas
picturerecorder -> picture
picture -> image

image -> to a fricking png!!
https://github.com/flutter/flutter/issues/6774
toByteData save!

Write to png and svg
https://skia.org/user/api/canvas

  SkCanvas* recordingCanvas = recorder.beginRecording(SkIntToScalar(width),
                                                        SkIntToScalar(height));
    draw(recordingCanvas);
    sk_sp<SkPicture> picture = recorder.finishRecordingAsPicture();
    picture->toImage(100,100);
        
# Build flutter engine
## PATH
export PATH=/Users/david/src/engine/src/third_party/android_tools/sdk/platform-tools/:/Users/david/flutter/depot_tools/:$PATH
## Create Makefiles
./flutter/tools/gn --ios --unoptimized --simulator
## Build code
ninja -C out/ios_debug_sim_unop


/*  Dart_Handle canvasimage = Dart_GetNativeArgument(arguments, 0);
  if (!Dart_IsNull(canvasimage)) {
      CanvasImage* decoded = tonic::DartConverter<CanvasImage*>::FromDart(canvasimage);      
      sk_sp<SkData> png(decoded->image()->encode(SkEncodedImageFormat::kPNG, 100));
      Dart_Handle result = tonic::DartConverter<tonic::Uint8List>::ToDart((uint8_t*)png->data(),png->size());
}*/

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
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png -w60 -h60
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png -w29 -h29
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png -w58 -h58
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png -w87 -h87
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png -w40 -h40
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=Icon-App-40x40@2x.png -w80 -h80
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png -w120 -h120
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png -w120 -h120
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png -w180 -h180
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png -w76 -h76
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png -w152 -h152
inkscape ~/src/tessellationapp/icon.svg -a 0:-6.933:320:313.067 --export-png=ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png -w167 -h167

inkscape ~/src/tessellationapp/lib/icon.svg -a 0:-6.933:320:313.067 --export-png=android/app/src/main/res/mipmap-mdpi/ic_launcher.png -w48 -h48
inkscape ~/src/tessellationapp/lib/icon.svg -a 0:-6.933:320:313.067 --export-png=android/app/src/main/res/mipmap-hdpi/ic_launcher.png -w72 -h72
inkscape ~/src/tessellationapp/lib/icon.svg -a 0:-6.933:320:313.067 --export-png=./android/app/src/main/res/mipmap-xhdpi/ic_launcher.png -w96 -h96
inkscape ~/src/tessellationapp/lib/icon.svg -a 0:-6.933:320:313.067 --export-png=./android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png -w144 -h144
inkscape ~/src/tessellationapp/lib/icon.svg -a 0:-6.933:320:313.067 --export-png=./android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -w192 -h192


### image transformer
Only convert the image part not the whole page with -a 0:-6.933:320:313.067
Run build parts in de pubspec.yml
$ flutter packages pub build
https://github.com/Fox32/image_transformer/blob/master/lib/image_transformer.dart

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
  
https://github.com/long1eu/material_pickers

canvas to image
###
https://chromium.googlesource.com/external/github.com/flutter/flutter/+/v0.0.20-alpha/examples/widgets/gestures.dart    
PictureRecorder 
 canvas
picturerecorder -> picture
picture -> image

image -> to a fricking png!!
https://github.com/flutter/flutter/issues/6774

toByteData save!
https://github.com/flutter/flutter/issues/11648

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

# controllers
https://docs.flutter.io/flutter/widgets/TextEditingController-class.html
set the zoom and the figure?


#colors
https://github.com/MichaelFenwick/Color/blob/master/lib/hex_color.dart
toRadixString(16).padLeft(2, '0') 
int.parse(_json['color1'],radix:16)

#android

##emulator
~/Library/Android/sdk/tools/emulator -avd Android_Accelerated_x86
https://developer.android.com/studio/run/emulator-commandline.html

#zoomable
https://github.com/perlatus/flutter_zoomable_image/
https://material.io/guidelines/patterns/gestures.html

##introduction
show overaly image with move zoom etc.

## color bar kiezen kleuren
pull up
met swipe left right kleuren palette
- red
- pink
- purple
- deep purple

- indigo
- blue
- light blue
- teal 

- green
- light green
- lime
- yellow

- amber
- orange
- deep orange
- brown

- black

21 * 10 
https://material.io/guidelines/style/color.html#color-color-palette
https://github.com/dart-flitter/flutter_color_picker


##Fill polygon

###Point in polygon
http://alienryderflex.com/polygon/

###Fill polygon
http://alienryderflex.com/polygon_fill/

# share image

## android

https://stackoverflow.com/questions/31162638/grant-permission-required-for-external-storage-in-android-m

File f=new File("full image path");
Uri uri = Uri.parse("file://"+f.getAbsolutePath());
Intent share = new Intent(Intent.ACTION_SEND);
share.putExtra(Intent.EXTRA_STREAM, uri);
share.setType("image/*");
share.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
context.startActivity(Intent.createChooser(share, "Share image File"));

### use file content provider
import com.android.support.v4
/Users/david/flutter/examples/plugins/packages/local_auth/android

## ios
NSData *compressedImage = UIImageJPEGRepresentation(self.resultImage, 0.8 );
NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
NSString *imagePath = [docsPath stringByAppendingPathComponent:@"image.jpg"];
NSURL *imageUrl     = [NSURL fileURLWithPath:imagePath];

[compressedImage writeToURL:imageUrl atomically:YES]; // save the file
UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[ @"Check this out!", imageUrl ] applicationActivities:nil];

# open simulator

## ios
$ open -a Simulator.app

## android
https://developer.android.com/studio/run/emulator-commandline.html
 
 $ ~/Library/Android/sdk/tools/emulator @nexus &
 

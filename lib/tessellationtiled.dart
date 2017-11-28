import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';

import 'package:vector_math/vector_math_64.dart' show Vector3;

import 'tessellationfigure.dart';

class TessellationTiledPainter extends CustomPainter {
  final TessellationFigure figure;
  final double dscale;
  TessellationTiledPainter(this.figure, this.dscale);

  @override
  void paint(Canvas canvas, Size size) {
    
    figure.tessellate(
          canvas,
          new Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero)),
          dscale);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
 
}

class TessellationTiled extends StatelessWidget {
  TessellationFigure figure;
  TessellationTiled({Key key, this.figure}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
        child: new Container(),
        isComplex: true,
        painter: new TessellationTiledPainter(figure,40.0));
  }
}

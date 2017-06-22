import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';

import 'package:vector_math/vector_math_64.dart' show Vector3;

import 'tessellationline.dart';

class TessellationFigure {
  TessellationFigure() {

  }

  final Paint _paint = new Paint()..color = const Color(0xFF00FF00)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0/50;

  double gridincx, gridincy, shiftx, shifty;
  int sequence, rotdiv;
  List<TessellationLine> _lines = new List<TessellationLine>();
  List<Color> _colors = new List(4);

  void initWithSquare() {
    gridincx = 1.0;
    gridincy = 1.0;
    shiftx = 0.0;
    shifty = 1.0;

    rotdiv = 1;
    sequence = 0;

    Matrix4 T = new Matrix4.identity()
      ..translate(1.0, 0.0, 0.0);
    TessellationLine line1  = new TessellationLine(T);
    line1.addPoint(new Offset(0.0, 0.0));
    line1.addPoint(new Offset(0.0, 1.0));
    _lines.add(line1);

    Matrix4 T2 = new Matrix4.identity()
      ..translate(0.0, -1.0 ,0.0);
    TessellationLine line2  = new TessellationLine(T2);
    line2.addPoint(new Offset(0.000003, 1.0));
    line2.addPoint(new Offset(1.0, 1.0));

    _lines.add(line2);
  }
  
  void fromJson(Map data) {
    
  }

  Path toPath() {
    final Path p = new Path();
    if (_lines.length == 0) return p;
    // todo create continues figure
    TessellationLine l1 = _lines.elementAt(0);
    _lines.forEach((line1) => p.addPath(line1.toPath(), Offset.zero));
    if (sequence==0) {
      _lines.forEach((line3) => p.addPath(line3.toPathC(),Offset.zero));
    } else {
      _lines.reversed.forEach((line3) => p.addPath(line3.toPathC(),Offset.zero));
    }
    return p;
  }

  void paint(Canvas canvas, _) {
    canvas.save();
    canvas.translate(100.0, 100.0);
    canvas.scale(100.0, 100.0);

    canvas.drawPath(toPath(), _paint);
    canvas.restore();
  }
}
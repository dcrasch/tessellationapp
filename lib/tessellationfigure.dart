import 'dart:convert';
import 'dart:io';
import 'dart:math';

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

  TessellationFigure.fromJson(Map _json) {
    // TODO check for types
    gridincx = _json['gridincx'];
    gridincy = _json['gridincy'];
    shiftx = _json['shiftx'];
    shifty = _json['shifty'];
    rotdiv = _json['rotdiv'];
    sequence = _json['sequence'];
    _lines = _json['lines'].map((value) => new TessellationLine.fromJson(value)).toList();
    print('done');
  }

  Map<String, Object> toJson() {
    final Map<String, Object> _json = new Map<String, Object>();
    // TODO
    return _json;
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
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

  double rectsize = 2.0/50;

  double gridincx, gridincy, shiftx, shifty;
  int sequence, rotdiv;
  List<TessellationLine> _lines = new List<TessellationLine>();
  List<Color> _colors = new List(4);
  String description;

  TessellationFigure.fromJson(Map _json) {
    // TODO check for types
    description = _json['description'];
    gridincx = _json['gridincx'];
    gridincy = _json['gridincy'];
    shiftx = _json['shiftx'];
    shifty = _json['shifty'];
    rotdiv = _json['rotdiv'];
    sequence = _json['sequence'];
    _lines = _json['lines'].map((value) => new TessellationLine.fromJson(value)).toList();
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
      _lines.reversed.forEach((line3) => p.addPath(line3.toPathC(), Offset.zero));
    }
    return p;
  }

  void paint(Canvas canvas, _) {
    canvas.drawPath(toPath(), _paint);
  }

  void addPoint(Offset point, PointIndexPath i) {
    Offset p1;
    if (i.corrp) {
      p1 = _lines[i.lineIndex].correspondingpoint(point);
    }
    else {
      p1 = point;
    }
    _lines[i.lineIndex].insertPointAt(i.pointIndex,p1);
  }

  PointIndexPath leftcreate(Offset point) {
    int counter = 0;
    PointIndexPath selectedpointindex;
    for (TessellationLine line in _lines) {
      selectedpointindex = line.hitline(point, rectsize);
      if (selectedpointindex != null ) {
        selectedpointindex.lineIndex = counter;
        return selectedpointindex;
      }
      counter++;
    }
    return null;
  }

  PointIndexPath leftdown(Offset point) {
    int counter = 0;
    PointIndexPath selectedpointindex;
    for (TessellationLine line in _lines) {
      selectedpointindex = line.hitendpoint(point, rectsize);
      if (selectedpointindex != null ) {
        selectedpointindex.lineIndex = counter;
        return selectedpointindex;
      }
      counter++;
    }
    return null;
  }

  bool drag(Offset point, PointIndexPath i) {
    Offset p1;
    if (i != null) {
      if (i.corrp) {
        p1 = _lines[i.lineIndex].correspondingpoint(point);
      }
      else {
        p1 = point;
      }
      _lines[i.lineIndex].replacePointAt(i.pointIndex, p1);
      return true;
    }
    return false;
  }

  Offset getPoint(PointIndexPath i) {
    Offset point = _lines[i.lineIndex].getPointAt(i.pointIndex);
    return point;
  }
}
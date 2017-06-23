import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';

import 'package:vector_math/vector_math_64.dart' show Vector3;

class PointIndexPath {
  PointIndexPath(this.lineIndex, this.pointIndex, this.corrp);
  int pointIndex;
  int lineIndex;
  bool corrp;
}

class TessellationLine {
  double human_angle = 0.0;
  List<Offset> _points = new List<Offset>();
  Matrix4 transform = new Matrix4.identity();
  Matrix4 ci = new Matrix4.identity();

  TessellationLine(this.transform) {
    ci = new Matrix4.inverted(transform);
  }

  final Paint _paint = new Paint()..color = const Color(0xFF00FF00)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  TessellationLine.fromJson(Map _json) {
    // TODO check for types
    transform = new Matrix4.identity()
      ..translate(_json['tx'], _json['ty'])
      ..rotateZ(_json['angle']/180.0*PI);
    ci = new Matrix4.inverted(transform);
    _points = _json['points'].map((value) => new Offset(value['x'],value['y'])).toList();
  }

  void addPoint(Offset point) {
    _points.add(point);
  }

  void replacePointAt(int i, Offset point) {
    _points[i] = point;
  }

  void removePointAt(int i) {
    _points.removeAt(i);
  }

  List<Offset> cpoints() {
    return _points;
  }

  Path toFirstPoint() {
    final Path p = new Path();
    if (_points.length == 0) return p;
    Offset p1 = _points.elementAt(0);
    p.moveTo(p1.dx,p1.dy);
    return p;
  }

  Path toPath() {
    final Path p = new Path();
    if (_points.length == 0) return p;
    for (Offset p2 in _points) {
      p.lineTo(p2.dx, p2.dy);
    }
    return p;
  }

  Path toPathC() {
    // fix initial start at zero
    final Path px = new Path();
    if (_points.length == 0) return px;
    Offset first = _points.elementAt(0);
    Offset p4x = MatrixUtils.transformPoint(transform, first);
    px.moveTo(p4x.dx, p4x.dy);

    for (Offset p3 in _points) {
      Offset p4 = MatrixUtils.transformPoint(transform, p3);
      px.lineTo(p4.dx, p4.dy);
    }
    return px;
  }

  bool breakline(Offset p1, Offset p2, Offset current, double rectsize) {
    Offset d = p1-p2;
    double r = d.distance;
    if (r>0) {
      double distancefromline = ((current.dx * d.dy - current.dy * d.dx +
          d.dx * point2.dy - d.dy * point2.dx) / r).abs;
      if ((distancefromline < rectsize) &&
          ((current-p1).distance < r) &&
          ((current-p2).distance < r)) {
        return true;
      }
    }
    return false;
  }

  bool hit(Offset p1, Offset p2, double rectsize) {
    final Offset d = p1-p2;
    return ((d.dx > rectsize) &&
        (d.dx < -rectsize) &&
        (d.dy > rectsize) &&
        (d.dy < -rectsize));
  }

  PointIndexPath hitendpoint(Offset p1, double rectsize) {
    int counter = 0;
    Offset p2 = MatrixUtils.transformPoint(ci, p1);
    for (Offset point in _points) {
      if ((counter > 0) && (counter < maxPointIndex)) {
        if (hit(p1, point, rectsize)) {
          return new PointIndexPath(0, counter, false);
        }
        if (hit(p2, point, rectsize)) {
          return new PointIndexPath(0,counter, true);
        }
      }
      counter++;
    }
    return null;
  }

  PointIndexPath hitline(Offset p1, double rectsize) {
    Offset previous;
    int counter = 0;
    Offset p2 = MatrixUtils.transformPoint(ci, p1);
    for (Offset current in _points) {
      if (counter>0) {
        if (breakline(current, previous, p1, rectsize)) {
          return new PointIndexPath(0, counter, false);
        }
        if (breakline(current, previous, p2, rectsize)) {
          return new PointIndexPath(0, counter, true);
        }
        counter++;
        previous = current;
      }
    }
    return null;
  }


  Rect fitrect() {
    // TODO
  }

  Offset correspondingpoint(Offset p1) {
    return  MatrixUtils.transformPoint(transform, p1);
  }
}

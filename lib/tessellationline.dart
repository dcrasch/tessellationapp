import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';

class TessellationLine {
  TessellationLine(this.transform) {
  }

  final Paint _paint = new Paint()..color = const Color(0xFF00FF00)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;
  double human_angle = 0.0;
  List<Offset> _points = new List<Offset>();
  Matrix4 transform = new Matrix4.identity();

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
    //broken??? start at zero??
    final Path px = new Path();
    if (_points.length == 0) return px;
    for (Offset p3 in cpoints()) {
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

  bool hit(Offset p1, Offset current, double rectsize) {
    final Offset d = p1-p2;
    return ((d.dx > rectsize) &&
        (d.dx < -rectsize) &&
        (d.dy > rectsize) &&
        (d.dy < -rectsize));
  }
 
  int hitline(Offset p1, double rectsize) { return 0; }
  
  int dobreakline(Offset p1, double rectsize) {
    return 0;
  }
  
  Rect fitrect() {
  }

  Offset correspondingpoint(Offset p1) {
    return  MatrixUtils.transformPoint(transform, p1);
  }
}

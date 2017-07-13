import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';

import 'package:vector_math/vector_math_64.dart' show Vector3;

import 'tessellationline.dart';

class TessellationFigure {
  TessellationFigure() {}

  final Paint _paint = new Paint()
    ..color = const Color(0xFFFFFF00)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0 / 50;

  double rectsize = 2.0 / 50;

  double gridincx, gridincy, shiftx, shifty;
  int sequence, rotdiv;
  List<TessellationLine> _lines = new List<TessellationLine>();
  List<Color> _colors = new List(4);
  String description;
  String uuid;

  TessellationFigure.fromJson(Map _json) {
    // TODO check for types
    description = _json['description'];
    gridincx = _json['gridincx'];
    gridincy = _json['gridincy'];
    shiftx = _json['shiftx'];
    shifty = _json['shifty'];
    rotdiv = _json['rotdiv'];
    sequence = _json['sequence'];
    if (_json.containsKey('uuid')) {
      uuid = _json['uuid'];
    } else {
      uuid = '';
    }

    _lines = _json['lines']
        .map((value) => new TessellationLine.fromJson(value))
        .toList();

    _colors[0] = new Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
    _colors[1] = new Paint()
      ..color = const Color(0xFF0000FF)
      ..style = PaintingStyle.fill;
    _colors[2] = new Paint()
      ..color = const Color(0xFF000033)
      ..style = PaintingStyle.fill;
    _colors[3] = new Paint()
      ..color = const Color(0xFFFF0000)
      ..style = PaintingStyle.fill;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _json = new Map<String, dynamic>();
    _json['description'] = description;
    _json['uuid'] = uuid;
    _json['gridincx'] = gridincx;
    _json['gridincy'] = gridincy;
    _json['shiftx'] = shiftx;
    _json['shifty'] = shifty;
    _json['rotdiv'] = rotdiv;
    _json['sequence'] = sequence;
    _json['lines'] = _lines.map((value) => value.toJson()).toList();
    return _json;
  }

  Path toPath() {
    final Path p = new Path();
    if (_lines.length == 0) return p;
    TessellationLine l1 = _lines.elementAt(0);
    l1.addStartToPath(p);
    _lines.forEach((line1) => line1.addToPath(p));
    if (sequence == 0) {
      _lines.forEach((line3) => line3.addToPathC(p));
    } else {
      _lines.reversed.forEach((line3) => line3.addToPathC(p));
    }
    return p;
  }

  void tessellate(Canvas canvas, Rect rect) {
    final Path fp = toPath();
    double dscale = 80.0; //0.5; // @TODO !!
    double sx = 0.0;
    double sy = 0.0;
    double rot = 0.0;
    double igx = dscale * gridincx;
    double igy = dscale * gridincy;
    double shx = dscale * shiftx;
    double shy = dscale * shifty;
    double minx;
    double maxx;
    double miny;
    double maxy;
    int row = 0;
    int color;
    double screenwidth = rect.width;
    double screenheight = rect.height;
    for (int currentdiv = 1; currentdiv <= rotdiv; currentdiv++) {
      rot = 2 * PI * currentdiv / rotdiv;
      minx = -igx * 2;
      maxx = screenwidth + igx;
      miny = -igy * 2;
      maxy = screenheight + igy;
      while (miny <= maxy) {
        sx = minx;
        sy = miny;
        if (sequence == 0) {
          color = row % 2;
        }
        while (sx <= maxx) {
          if (sequence == 1) {
            color = currentdiv - 1;
          }
          if ((sequence == 0) && (gridincy < gridincx)) {
            // for hexagons
            color = row % 4;
          }
          canvas.save();
          canvas.translate(sx, sy);
          canvas.scale(dscale, dscale);
          canvas.rotate(rot);
          Paint p = _colors[color % 4];
          canvas.drawPath(fp, p);
          canvas.restore();
          sx += igx;
          //sy += shy;
          color++;
        }
        minx += shx;
        miny += igy;
        if (minx > -igx) {
          minx -= igx;
          maxy -= shy;
        }
        row++;
      }
    }
  }

  void paint(Canvas canvas, _) {
    canvas.drawPath(toPath(), _paint);
  }

  void addPoint(Offset point, PointIndexPath i) {
    Offset p1;
    if (i.corrp) {
      p1 = _lines[i.lineIndex].correspondingpoint(point);
    } else {
      p1 = point;
    }
    _lines[i.lineIndex].insertPointAt(i.pointIndex, p1);
  }

  PointIndexPath leftcreate(Offset point) {
    int counter = 0;
    PointIndexPath selectedpointindex;
    for (TessellationLine line in _lines) {
      selectedpointindex = line.hitline(point, rectsize);
      if (selectedpointindex != null) {
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
      if (selectedpointindex != null) {
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
      } else {
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

  Rect fit() {
    TessellationLine line1 = _lines[0];
    Rect q = line1.fitrect();
    for (TessellationLine line in _lines) {
      q = q.intersect(line.fitrect); // union???
    }
    return q;
  }
}

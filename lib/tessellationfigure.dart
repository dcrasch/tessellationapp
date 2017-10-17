import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';

import 'package:image/image.dart' as Im;
import 'package:vector_math/vector_math_64.dart' show Vector3;

import 'polygonfill.dart';
import 'tessellationline.dart';

class TessellationFigure {
  TessellationFigure() {}

  final Paint _paint = new Paint()
    ..color = const Color(0xFFFFFF00)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0 / 50
    ..strokeJoin = StrokeJoin.round;

  double rectsize = 2.0 / 50;

  double gridincx, gridincy, shiftx, shifty;
  int sequence, rotdiv;
  List<TessellationLine> _lines = new List<TessellationLine>();
  List<Color> colors = new List(4);
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

    if (_json.containsKey('color1')) {
      colors[0] = new Color(0xFF000000 | int.parse(_json['color1'], radix: 16));
      colors[1] = new Color(0xFF000000 | int.parse(_json['color2'], radix: 16));
      colors[2] = new Color(0xFF000000 | int.parse(_json['color3'], radix: 16));
      colors[3] = new Color(0xFF000000 | int.parse(_json['color4'], radix: 16));
    } else {
      colors[0] = const Color(0xFFFFFFFF);
      colors[1] = const Color(0xFF000000);
      colors[2] = const Color(0xFF545454);
      colors[3] = const Color(0xFFA8A8A8);

      if (sequence == 0) {
        if (gridincy == gridincx) {
          if ((shiftx == 0.0)) {
            colors[2] = colors[0];
            colors[3] = colors[1];
          }
        }
      } else {
        if (rotdiv % 2 == 0) {
          colors[2] = colors[0];
          colors[3] = colors[1];
        }
      }
    }
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
    _json['color1'] = colors[0].red.toRadixString(16).padLeft(2, '0') +
        colors[0].green.toRadixString(16).padLeft(2, '0') +
        colors[0].blue.toRadixString(16).padLeft(2, '0');
    _json['color2'] = colors[1].red.toRadixString(16).padLeft(2, '0') +
        colors[1].green.toRadixString(16).padLeft(2, '0') +
        colors[1].blue.toRadixString(16).padLeft(2, '0');
    _json['color3'] = colors[2].red.toRadixString(16).padLeft(2, '0') +
        colors[2].green.toRadixString(16).padLeft(2, '0') +
        colors[2].blue.toRadixString(16).padLeft(2, '0');
    _json['color4'] = colors[3].red.toRadixString(16).padLeft(2, '0') +
        colors[3].green.toRadixString(16).padLeft(2, '0') +
        colors[3].blue.toRadixString(16).padLeft(2, '0');

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

  List<Offset> toPoly() {
    final List<Offset> p = new List<Offset>();
    _lines.forEach((line1) => line1.addToPoly(p));
    if (sequence == 0) {
      _lines.forEach((line3) => line3.addToPolyC(p));
    } else {
      _lines.reversed.forEach((line3) => line3.addToPolyC(p));
    }
    return p;
  }

  
  void tessellate(Canvas canvas, Rect rect, double dscale) {
    final Path fp = toPath();
    List<Offset> grid = figuregrid(rect, dscale);
    int row = 0;
    double rot = 0.0;
    int color;
    for (int currentdiv = 1; currentdiv <= rotdiv; currentdiv++) {
      rot = 2 * math.PI * currentdiv / rotdiv;

      for (List<Offset> gridrow in grid) {
        if (sequence == 0) {
          color = row % 2;
        }
        for (Offset gridpoint in gridrow) {
          // todo rewrite to generator or something
          if (sequence == 1) {
            color = currentdiv - 1;
          }
          if (sequence == 0) {
            if (gridincy < gridincx) {
              // for hexagons
              color = row % 3;
            }
          }
          canvas.save();
          canvas.translate(gridpoint.dx, gridpoint.dy);
          canvas.scale(dscale, dscale);
          canvas.rotate(rot);
          Color c = colors[color % 4];

          Paint p = new Paint()
            ..color = c
            ..style = PaintingStyle.stroke;
          canvas.drawPath(fp, p);

          Paint p2 = new Paint()
            ..color = c
            ..style = PaintingStyle.fill; //strokeAndFill
          canvas.drawPath(fp, p2);
          canvas.restore();
        }
        row++;
      }
    }
  }

Future<Null>  tessellateimage(Im.Image image, double dscale) async {
    Rect rect = const Offset(0.0, 0.0) & const Size(320.0, 240.0);
    List<Offset> grid = figuregrid(rect, dscale);
    int row = 0;
    double rot = 0.0;
    int color;
    List<Offset> poly = this.toPoly();
    for (int currentdiv = 1; currentdiv <= rotdiv; currentdiv++) {
      rot = 2 * math.PI * currentdiv / rotdiv;

      for (List<Offset> gridrow in grid) {
        if (sequence == 0) {
          color = row % 2;
        }
        for (Offset gridpoint in gridrow) {
          // todo rewrite to generator or something
          if (sequence == 1) {
            color = currentdiv - 1;
          }
          if (sequence == 0) {
            if (gridincy < gridincx) {
              // for hexagons
              color = row % 3;
            }
          }
          Color c = colors[color % 4];

          Matrix4 t = new Matrix4.identity()
            ..translate(gridpoint.dx, gridpoint.dy)
            ..scale(dscale)
            ..rotateZ(rot);
          
          await fillPolygon(image, poly, t, c);
        }
        row++;
      }
    }
  }

  List<List<Offset>> figuregrid(Rect rect, double dscale) {
    List<List<Offset>> grid = [[]];
    double sx = 0.0;
    double sy = 0.0;

    double igx = dscale * gridincx;
    double igy = dscale * gridincy;
    double shx = dscale * shiftx;
    double shy = dscale * shifty;
    double minx;
    double maxx;
    double miny;
    double maxy;
    int row = 0;
    double screenwidth = rect.width;
    double screenheight = rect.height;
    minx = -igx * 2;
    maxx = screenwidth + igx;
    miny = -igy * 2;
    maxy = screenheight + igy;
    while (miny <= maxy) {
      sx = minx;
      sy = miny;
      List<Offset> gridrow = [];
      while (sx <= maxx) {
        sx += igx;
        //sy += shy;
        gridrow.add(new Offset(sx, sy));
      }
      grid.add(gridrow);
      minx += shx;
      miny += igy;
      if (minx > -igx) {
        minx -= igx;
        maxy -= shy;
      }
    }
    return grid;
  }

  void paint(Canvas canvas, _) {
    List<Offset> poly = toPoly();
    Path p = new Path();
    p.addPolygon(poly, true);
    canvas.drawPath(p, _paint);
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
      Rect k = line.fitrect();
      q = new Rect.fromLTRB(math.min(q.left, k.left), math.min(q.top, k.top),
          math.max(q.right, k.right), math.max(q.bottom, k.bottom));
    }
    return q;
  }
}

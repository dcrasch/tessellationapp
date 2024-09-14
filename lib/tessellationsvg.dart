import 'package:flutter/rendering.dart';
import 'package:tessellation/tessellationfigure.dart';
import 'dart:math' as math;

class TessellationSVG {
  static String convert(TessellationFigure f) {
    final StringBuffer svgBuffer = StringBuffer();
    svgBuffer
        .write('''<svg viewBox="0 0 400 400" xmlns="http://www.w3.org/2000/svg">
    <defs>''');
    svgBuffer.write(convertPoints(f.toPoly())); // Convert points from figure
    svgBuffer.write('''</defs>''');
    svgBuffer.write(composePlane(f)); // Compose the plane part
    svgBuffer.write('</svg>'); // Close the SVG tag
    return svgBuffer.toString();
  }

  static String convertPoints(List<Offset> points) {
    if (points.isEmpty) {
      return '';
    }
    final StringBuffer p = StringBuffer();
    final Iterator<Offset> it = points.iterator;
    if (it.moveNext()) {
      p.write("M${it.current.dx},${it.current.dy} ");
    }
    while (it.moveNext()) {
      p.write("L${it.current.dx},${it.current.dy} ");
    }
    p.write('z');
    return '<path d="${p.toString()}" id="figure" vector-effect="non-scaling-stroke"/>';
  }

  static String composePlane(TessellationFigure t) {
    final StringBuffer p = StringBuffer();

    double dscale = 70.0;
    Rect rect = Rect.fromLTWH(0, 0, 400, 400);
    List<List<Offset>> grid = t.figuregrid(rect, dscale);
    int row = 0;
    double rot = 0.0;
    int color = 0;
    for (int currentdiv = 1; currentdiv <= t.rotdiv!; currentdiv++) {
      rot = 2 * math.pi * currentdiv / t.rotdiv!;
      for (List<Offset> gridrow in grid) {
        if (t.sequence == 0) {
          color = row % 2;
        }
        for (Offset gridpoint in gridrow) {
          // todo rewrite to generator or something
          if (t.sequence == 1) {
            color = currentdiv - 1;
          }
          if (t.sequence == 0) {
            if (t.gridincy! < t.gridincx!) {
              // for hexagons
              color = row % 3;
            }
          }
          String m =
              generateMatrix(rot, dscale, dscale, gridpoint.dx, gridpoint.dy);
          String c =
              t.colors![color % 4].red.toRadixString(16).padLeft(2, '0') +
                  t.colors![color % 4].green.toRadixString(16).padLeft(2, '0') +
                  t.colors![color % 4].blue.toRadixString(16).padLeft(2, '0');
          p.writeln('<use fill="#${c}" href="#figure" transform="${m}"/>');
          color++;
        }
        row++;
      }
    }
    return p.toString();
  }

  static String generateMatrix(double rad, double scaleX, double scaleY,
      double translateX, double translateY) {
    double cosAngle = math.cos(rad);
    double sinAngle = math.sin(rad);

    // Apply rotation, scaling, and translation
    double m11 = cosAngle * scaleX;
    double m12 = -sinAngle * scaleY;
    double m21 = sinAngle * scaleX;
    double m22 = cosAngle * scaleY;
    double m31 = translateX;
    double m32 = translateY;

    return "matrix($m11,$m12,$m21,$m22,$m31,$m32)";
  }
}

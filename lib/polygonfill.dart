import 'dart:math' as math;
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'package:image/image.dart' as Im;

void fillPolygon(image, points) {
  List<Offset>poly = [];
  Matrix4 t = new Matrix4.identity()
    ..translate(60.0, 60.0)
    ..scale(50.0);
  for (Offset o in points) {
    Offset p = MatrixUtils.transformPoint(t, o);
    poly.add(p);
  }
  poly.remove(poly.first);

  /*
  String content = '<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"><polygon style=\"stroke:#660000; fill:#cc3333;\" points=\"';
  for (Offset p in poly) {
    content = content +  "${p.dx},${p.dy}\n ";
  }
  content = content + '\"/></svg>';
  print(content);
  */

  int polyCorners = poly.length;
  int nodes, pixelX, pixelY, i, j, swap;
  List<int> nodeX = new List(polyCorners);

  for (pixelY = 0; pixelY < 240; pixelY++) {

    // build nodes
    nodes = 0;
    j = polyCorners - 1;
    for (i = 0; i < polyCorners; i++) {
      Offset p = poly[i];
      Offset q = poly[j];
      if (p.dy < pixelY && q.dy >= pixelY ||
          q.dy < pixelY && p.dy >= pixelY) {
        nodeX[nodes++] =
          (p.dx + (pixelY - p.dy) / (q.dy - p.dy) * (q.dx - p.dx)).ceil();
      }
      j = i;
    }

    // sort nodes
    i = 0;
    while (i < nodes - 1) {
      if (nodeX[i] > nodeX[i + 1]) {
        swap = nodeX[i];
        nodeX[i] = nodeX[i + 1];
        nodeX[i + 1] = swap;
        if (i != 0) i--;
      } else {
        i++;
      }
    }

    // fill pixels
    for (i = 0; i < nodes; i += 2) {
      if (nodeX[i] >= 320) break;
      if (nodeX[i + 1] > 0) {
        if (nodeX[i] < 0) {
          nodeX[i] = 0;
        }
        if (nodeX[i + 1] > 320) {
          nodeX[i + 1] = 320;
        }
        for (pixelX = nodeX[i]; pixelX < nodeX[i + 1]; pixelX++) {
          Im.drawPixel(image, pixelX, pixelY, Im.getColor(255, 0, 0));
        }
      }
    }
  }

  /*
  Offset oldp = poly.last;
  for (Offset p2 in poly) {
    Im.drawLine(image,
        oldp.dx.ceil(), oldp.dy.ceil(),
        p2.dx.ceil(), p2.dy.ceil(),
        Im.getColor(0, 255, 0));
    oldp=p2;
  }
  */
}

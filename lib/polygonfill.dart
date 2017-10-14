import 'dart:io' as Io;
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';

import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'package:image/image.dart' as Im;

void fillPolygon(image, poly) {
  int polyCorners = poly.length;
  for (Offset o in poly) {
    print("${o.dx},${o.dy}");
  }
  Matrix4 t = new Matrix4.identity()
    ..translate(60.0, 60.0)
    ..scale(50.0);

  int nodes, pixelX, pixelY, i, j, swap;
  List<int> nodeX = new List(polyCorners);

  for (pixelY = 0; pixelY < 240; pixelY++) {
    nodes = 0;
    j = polyCorners - 1;
    for (i = 0; i < polyCorners; i++) {
      Offset p = MatrixUtils.transformPoint(t, poly[i]);
      Offset q = MatrixUtils.transformPoint(t, poly[j]);
      if (p.dy < pixelY && q.dy >= pixelY || q.dy < pixelY && p.dy >= pixelY) {
        nodeX[nodes++] =
            (p.dx + (pixelY - p.dy) / (q.dy - p.dy) * (q.dx - p.dx)).ceil();
      }
      j = i;
    }

    i = 0;
    while (i < nodes - 1) {
      if (nodeX[i] > nodeX[i + 1]) {
        swap = nodeX[i];
        nodeX[i] = nodeX[i + 1];
        nodeX[i + 1] = swap;
        if (i > 0) {
          i--;
        } else {
          i++;
        }
      }

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
  }
  print(image);
}

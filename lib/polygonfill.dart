import 'dart:math' as math;
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'package:image/image.dart' as Im;

void fillPolygon(image, points, transform, c) {
  
  List<Offset>poly = [];
  for (Offset o in points) {
    Offset p = MatrixUtils.transformPoint(transform, o);
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

  for (pixelY = 0; pixelY < image.height; pixelY++) {

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
      if (nodeX[i] >= image.width) break;
      if (nodeX[i + 1] > 0) {
        if (nodeX[i] < 0) {
          nodeX[i] = 0;
        }
        if (nodeX[i + 1] > image.width) {
          nodeX[i + 1] = image.width;
        }
        for (pixelX = nodeX[i]; pixelX < nodeX[i + 1]; pixelX++) {
          Im.drawPixel(image, pixelX, pixelY, Im.getColor(c.red, c.green, c.blue));
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
        Im.getColor(c.red, c.green, c.blue),
                antialias:false);
    oldp=p2;
  }
  */

}

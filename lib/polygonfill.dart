import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';

import 'package:image/image.dart' as Im;

void fillPolygon(image, poly, c, minx, miny, maxx, maxy) {
  // TODO check if minx, miny, maxx and maxy are in bounds of the image
  int polyCorners = poly.length;
  int nodes, pixelX, pixelY, i, j, swap;
  List<int> nodeX = new List(polyCorners);

  for (pixelY = miny; pixelY < maxy; pixelY++) {
    // build nodes
    nodes = 0;
    j = polyCorners - 1;
    for (i = 0; i < polyCorners; i++) {
      Offset p = poly[i];
      Offset q = poly[j];
      if (p.dy < pixelY && q.dy >= pixelY || q.dy < pixelY && p.dy >= pixelY) {
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
      if (nodeX[i] >= maxx) break;
      if (nodeX[i + 1] > minx) {
        if (nodeX[i] < minx) {
          nodeX[i] = minx;
        }
        if (nodeX[i + 1] > maxx) {
          nodeX[i + 1] = maxx;
        }
        for (pixelX = nodeX[i]; pixelX < nodeX[i + 1]; pixelX++) {
          image[pixelX + pixelY * image.width] = c;
          //Im.drawPixel(image, pixelX, pixelY, c);
        }
      }
    }
  }

  // draw borders
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

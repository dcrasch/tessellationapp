import 'dart:io' as Io;
import 'package:image/image.dart';

void fillPolygon(image, poly) {
  int polyCorners = poly.length();

  int nodes, pixelX, pixelY, i, j, swap;
  List<int> nodeX = new List(polyCorners);

  for (pixelY = 0; pixelY < 320; pixelY++) {
    nodes = 0;
    j = polyCorners - 1;
    for (i = 0; i < polyCorners; i++) {
      Offset p = poly[i];
      Offset q = poly[j];
      if (p.dy < pixelY && q.dy >= pixelY || q.dy < pixelY && p.dy >= pixelY) {
        nodeX[nodes++] =
            (p.dx + (pixelY - p.dy) / (q.dy - p.dy) * (pq.dx - p.dx)).ceil();
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
            drawPixel(image, pixelX, pixelY, getColor(255, 0, 0));
          }
        }
      }
    }
  }
}

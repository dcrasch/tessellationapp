import 'dart:io' as Io;
import 'package:image/image.dart';

void main() {
  Image image = new Image(320, 240);
  
  List<double> polyX = [100,10,200,100];
  List<double> polyY = [10,200,200,100];
  int polyCorners = 4;

  int nodes,pixelX, pixelY, i, j, swap;
  List<int> nodeX = new List(polyCorners);
  
  for (pixelY=0; pixelY<240; pixelY++) {
    nodes=0;
    j= polyCorners-1;
    for (i=0; i<polyCorners; i++) {
      if (polyY[i]<pixelY && polyY[j]>=pixelY || polyY[j]<pixelY && polyY[i]>=pixelY) {
        nodeX[nodes++] = (polyX[i]+(pixelY-polyY[i])/(polyY[j]-polyY[i]) 
            * (polyX[j]-polyX[i])).ceil();
      }
      j=i;
    }
    
    i=0;
    while (i<nodes-1) {
      if (nodeX[i]>nodeX[i+1]) {
        swap = nodeX[i];
        nodeX[i] = nodeX[i+1];
        nodeX[i+1] = swap;
        if (i>0) {
          i--; 
        }
        else {
          i++;
        }
      }

      for (i=0; i<nodes; i+=2) {
        if (nodeX[i]>=320) break;
        if (nodeX[i+1]>0) {
          if (nodeX[i]<0) {
            nodeX[i] = 0;
          }
          if (nodeX[i+1]>320) {
            nodeX[i+1] = 320;
          }
          for (pixelX=nodeX[i]; pixelX<nodeX[i+1]; pixelX++) {
            drawPixel(image,pixelX, pixelY, getColor(255, 0, 0));
          }
        }
      }
    }       
  }
    
  

  List<int> png = encodePng(image);
  // Save it to disk
  new Io.File('test.png')
      ..writeAsBytesSync(png);
}
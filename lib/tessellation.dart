import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';

import 'tessellationfigure.dart';
import 'tessellationline.dart';

class RenderLines extends RenderConstrainedBox {
  RenderLines(this.figure) : super(additionalConstraints: const BoxConstraints.expand());

  TessellationFigure figure;
  PointIndexPath selectedPoint;
  
  Matrix4 transform = new Matrix4.identity()
    ..translate(100.0,150.0)
    ..scale(200.0);
  Matrix4 ci = new Matrix4.identity();

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    ci = new Matrix4.inverted(transform);
    Offset touchPoint = MatrixUtils.transformPoint(ci, event.position);
    if (event is PointerDownEvent) {
      selectedPoint = figure.leftdown(touchPoint);
      if (selectedPoint != null) {
        figure.drag(touchPoint, selectedPoint);
        markNeedsPaint();
      } else {
        selectedPoint = figure.leftcreate(touchPoint);
        if (selectedPoint != null) {
          figure.addPoint(touchPoint, selectedPoint);
        }
      }
    }
    if (event is PointerMoveEvent) {
      if (selectedPoint != null) {
        figure.drag(touchPoint, selectedPoint);
        markNeedsPaint();
      }
    }
    if (event is PointerUpEvent) {
      selectedPoint = null;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    print(size);
    canvas.drawRect(
        offset & size, new Paint()..color = const Color(0xFFFFFFFF));
    if (figure != null) {
      figure.tessellate(canvas);
      canvas.save();
      canvas.transform(transform.storage);
      figure.paint(canvas, offset);
      canvas.restore();
    }
    super.paint(context, offset);
  }
}

class LinesWidget extends SingleChildRenderObjectWidget {
  TessellationFigure figure;
  LinesWidget({Key key, Widget child, this.figure})
      : super(key: key, child: child);
  @override
  RenderLines createRenderObject(BuildContext context) =>
      new RenderLines(figure);
}

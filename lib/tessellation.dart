import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import 'tessellationfigure.dart';
import 'tessellationline.dart';

class TessellationPainter extends CustomPainter {
  final TessellationFigure figure;
  TessellationPainter(this.figure);

  Matrix4 transform = new Matrix4.identity()
    ..translate(100.0, 150.0)
    ..scale(200.0);
  Matrix4 ci = new Matrix4.identity();

  @override 
  void paint(Canvas canvas, Size size) {
    Offset offset = Offset.zero;
    canvas.drawRect(
        offset & size, new Paint()..color = const Color(0x00FFFFFF));
    if (figure != null) {
      Rect rect = offset & size;
      //figure.tessellate(canvas, rect);
      canvas.save();
      canvas.transform(transform.storage);
      figure.paint(canvas, offset);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

class TessellationWidget extends StatefulWidget {
  TessellationFigure figure;
  TessellationWidget({Key key, this.figure, this.onChanged}) : super(key:key);

  PointIndexPath selectedPoint;
  ValueChanged<TessellationFigure> onChanged;

  @override
  TessellationState createState() => new TessellationState();
}

class TessellationState extends State<TessellationWidget> {
  TessellationFigure figure;
  
  @override
  void initState() {
    super.initState();
    figure = widget.figure;
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    ci = new Matrix4.inverted(transform);
    Offset touchPoint = MatrixUtils.transformPoint(ci, event.position);
    if (event is PointerDownEvent) {
      selectedPoint = figure.leftdown(touchPoint);
      if (selectedPoint != null) {
        setState(() {
          figure.drag(touchPoint, selectedPoint);
        });
      } else {
        selectedPoint = figure.leftcreate(touchPoint);
        if (selectedPoint != null) {
          setState(() {
            figure.addPoint(touchPoint, selectedPoint);
          });
        }
      }
    }
    if (event is PointerMoveEvent) {
      if (selectedPoint != null) {
        setState(() {
          figure.drag(touchPoint, selectedPoint);
        });        
      }
    }
    if (event is PointerUpEvent) {
      selectedPoint = null;
    }
    if (widget.onChanged != null) {
      widget.onChanged(figure);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
        constraints: new BoxConstraints.expand(),
        child: new GestureDetector(
            
            //behaviour: HitTestBehavior.opaque,
            child: new CustomPaint(
                painter: new TessellationPainter(figure)
                )),
                             );
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void paint(PaintingContext context, Offset offset) {
  }
}
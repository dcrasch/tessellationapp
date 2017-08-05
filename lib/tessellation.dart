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
  PointIndexPath selectedPoint;
  Matrix4 transform = new Matrix4.identity()
    ..translate (100.0, 150.0)
    ..scale (200.0);
  Matrix4 ci = new Matrix4.identity();
  
  @override
  void initState() {
    super.initState();
    figure = widget.figure;
  }
    
  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
        constraints: new BoxConstraints.expand(),
        child: new GestureDetector(
            onPanStart: (details) {
              ci = new Matrix4.inverted(transform);
              RenderBox box = context.findRenderObject();
              Offset touchPoint = box.globalToLocal(details.globalPosition);
              touchPoint = MatrixUtils.transformPoint(ci, touchPoint);
              selectedPoint = figure.leftdown(touchPoint);
              if (selectedPoint != null) {
                setState(() {
                  figure.drag(touchPoint, selectedPoint);                  
                });
                if (widget.onChanged != null) {
                  widget.onChanged(figure);
                }
              }
              else {
                selectedPoint = figure.leftcreate(touchPoint);
                if (selectedPoint != null) {
                  setState(() {
                    figure.addPoint(touchPoint, selectedPoint);
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged(figure);
                  }
                }
              }
            },
            onPanUpdate: (details) {
              ci = new Matrix4.inverted(transform);
              RenderBox box = context.findRenderObject();
              Offset touchPoint = box.globalToLocal(details.globalPosition);
              touchPoint = MatrixUtils.transformPoint(ci, touchPoint);
               if (selectedPoint != null) {
                setState(() {
                  figure.drag(touchPoint, selectedPoint);
                });
                if (widget.onChanged != null) {
                  widget.onChanged(figure);
                }
               }
            },
            onPanEnd: (details) {
              selectedPoint = null;
            },
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
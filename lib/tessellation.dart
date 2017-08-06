import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import 'tessellationfigure.dart';
import 'tessellationline.dart';

class TessellationPainter extends CustomPainter {
  TessellationPainter(this.figure, this.transform);
  final TessellationFigure figure;
  Matrix4 transform;
  @override
  void paint(Canvas canvas, Size size) {
    Offset offset = Offset.zero;
    canvas.drawRect(
        offset & size, new Paint()..color = const Color(0x00FFFFFF));
    if (figure != null) {
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
  TessellationWidget({Key key, this.figure, this.onChanged, this.zoom})
      : super(key: key);
  TessellationFigure figure;
  ValueChanged<TessellationFigure> onChanged;
  ValueNotifier<Matrix4> zoom;

  PointIndexPath selectedPoint;
  @override
  TessellationState createState() => new TessellationState();
}

class TessellationState extends State<TessellationWidget> {
  TessellationFigure figure;
  PointIndexPath selectedPoint;
  Matrix4 transform;
  Matrix4 ci;


  @override
  void initState() {
    super.initState();
    widget.zoom.removeListener(_setRemoteZoom);
    widget.zoom.addListener(_setRemoteZoom);
    _setRemoteZoom();
  }

  @override
  void dispose() {
    //widget.zoom.removeListener(_setRemoveZoom);
    super.dispose();
  }

  void _setRemoteZoom() {
    setState(() {
      figure = widget.figure;
      transform = widget.zoom.value;
      ci = new Matrix4.inverted(transform);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: new BoxConstraints.expand(),
      child: new GestureDetector(
          onPanStart: (details) {
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
            } else {
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
              painter: new TessellationPainter(figure, transform))),
    );
  }
}
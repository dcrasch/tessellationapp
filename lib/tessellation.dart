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

  // zoom
  Offset _startingFocalPoint;

  Offset _previousOffset;
  Offset _offset = Offset.zero;

  double _previousZoom;
  double _zoom = 1.0;
  double _scale = 16.0;

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
          onScaleStart: (details) {
            _handlePanStart(context, details);
            _handleScaleStart(details);
          },
          onScaleUpdate: (details) {
            if (details.scale == 1.0) {
              _handlePanUpdate(context, details);
            } else {
              // two finger drag is with scale ~ 1 maybe long press drag
              _handleScaleUpdate(context.size, details);
            }
          },
          onScaleEnd: (details) {
            _handlePanEnd(details);
          },
          child: new CustomPaint(
              painter: new TessellationPainter(figure, transform))),
    );
  }

  void _handlePanStart(BuildContext context, ScaleStartDetails details) {
    RenderBox box = context.findRenderObject();
    Offset touchPoint = box.globalToLocal(details.focalPoint);
    print(touchPoint);
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
  }

  void _handlePanUpdate(BuildContext, ScaleUpdateDetails details) {
    RenderBox box = context.findRenderObject();
    Offset touchPoint = box.globalToLocal(details.focalPoint);
    touchPoint = MatrixUtils.transformPoint(ci, touchPoint);
    if (selectedPoint != null) {
      setState(() {
        figure.drag(touchPoint, selectedPoint);
      });
      if (widget.onChanged != null) {
        widget.onChanged(figure);
      }
    }
  }

  void _handlePanEnd(ScaleEndDetails details) {
    selectedPoint = null;
  }

  void _handleScaleStart(ScaleStartDetails d) {
    print(d);
    _startingFocalPoint = d.focalPoint / _scale;
    _previousOffset = _offset;
    _previousZoom = _zoom;
  }

  void _handleScaleUpdate(Size size, ScaleUpdateDetails d) {
    double newZoom = _previousZoom * d.scale;
    bool tooZoomedIn = 400.0 * _scale / newZoom <= size.width ||
        300.0 * _scale / newZoom <= size.height;
    if (tooZoomedIn) {
      return;
    }

    // Ensure that item under the focal point stays in the same place despite zooming
    final Offset normalizedOffset =
        (_startingFocalPoint - _previousOffset) / _previousZoom;
    final Offset newOffset = d.focalPoint / _scale - normalizedOffset * _zoom;

    print(d);
    setState(() {
      _zoom = newZoom;
      _offset = newOffset;
    });
  }
}

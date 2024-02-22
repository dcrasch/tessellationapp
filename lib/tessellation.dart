import 'package:flutter/material.dart';

import 'tessellationfigure.dart';
import 'tessellationline.dart';

class TessellationPainter extends CustomPainter {
  TessellationPainter(this.figure, this.transform, this.borderColor);
  final TessellationFigure? figure;
  final Matrix4? transform;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    Offset offset = Offset.zero;
    canvas.drawRect(
        offset & size, new Paint()..color = const Color(0x00FFFFFF));
    if (figure != null) {
      canvas.save();
      canvas.transform(transform!.storage);
      figure!.paint(canvas, offset, borderColor);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class TessellationWidget extends StatefulWidget {
  TessellationWidget(
      {Key? key,
      this.figure,
      required this.onChanged,
      required this.onAddPoint,
      required this.onModified,
      this.zoom})
      : super(key: key);
  final TessellationFigure? figure;

  final ValueChanged<TessellationFigure?> onChanged;
  final ValueChanged<(Offset, PointIndexPath)> onModified;
  final ValueChanged<(Offset, PointIndexPath)> onAddPoint;

  final ValueNotifier<Matrix4>? zoom; // TODO

  final PointIndexPath? selectedPoint = null; // TODO
  @override
  TessellationState createState() => new TessellationState();
}

class TessellationState extends State<TessellationWidget> {
  TessellationFigure? figure;
  PointIndexPath? selectedPoint;
  Matrix4? transform;
  late Matrix4 ci;

  // zoom
  Matrix4? _oldTransform;
  late Offset _startingFocalPoint;

  @override
  void initState() {
    super.initState();
    widget.zoom!.removeListener(_setRemoteZoom);
    widget.zoom!.addListener(_setRemoteZoom);
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
      transform = widget.zoom!.value;
      ci = new Matrix4.inverted(transform!);
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
              painter:
                  new TessellationPainter(figure, transform, Colors.yellow))),
    );
  }

  void _handlePanStart(BuildContext context, ScaleStartDetails details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset touchPoint = box.globalToLocal(details.focalPoint);
    bool _changed = false;
    touchPoint = MatrixUtils.transformPoint(ci, touchPoint);
    selectedPoint = figure!.leftdown(touchPoint);
    if (selectedPoint != null) {
      _changed = figure!.drag(touchPoint, selectedPoint);
      if (_changed && widget.onChanged != null) {
        widget.onChanged!(figure);
      }
    } else {
      selectedPoint = figure!.leftcreate(touchPoint);
      if (selectedPoint != null) {
        if (widget.onChanged != null) {
          widget.onAddPoint!((touchPoint, selectedPoint!));
        }
      }
    }
  }

  void _handlePanUpdate(BuildContext context, ScaleUpdateDetails details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset touchPoint = box.globalToLocal(details.focalPoint);
    touchPoint = MatrixUtils.transformPoint(ci, touchPoint);
    bool _changed = false;
    if (selectedPoint != null) {
      _changed = figure!.drag(touchPoint, selectedPoint);
      if (_changed == true && widget.onChanged != null) {
        widget.onChanged!(figure);
      }
    }
  }

  void _handlePanEnd(ScaleEndDetails details) {
    if (selectedPoint != null) {
      var touchPoint = this.figure!.getPoint(selectedPoint!);
      widget.onModified!((touchPoint, selectedPoint!));
    }
    selectedPoint = null;
  }

  void _handleScaleStart(ScaleStartDetails d) {
    _startingFocalPoint = d.focalPoint;
    _oldTransform = transform;
  }

  void _handleScaleUpdate(Size? size, ScaleUpdateDetails d) {
    Offset focal = d.focalPoint - _startingFocalPoint;
    Matrix4 newTransform = new Matrix4.identity()
      ..translate(_startingFocalPoint.dx, _startingFocalPoint.dy)
      ..scale(d.scale)
      ..translate(-_startingFocalPoint.dx + focal.dx,
          -_startingFocalPoint.dy + focal.dy);
    setState(() {
      transform = newTransform * _oldTransform;
      ci = new Matrix4.inverted(transform!);
    });
  }
}

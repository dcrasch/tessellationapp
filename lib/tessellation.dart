import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class TessellationLine {
  TessellationLine(this.transform);

  final Paint _paint = new Paint()..color = const Color(0xFF00FF00)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;
  double human_angle = 0.0;
  List<Offset> _lines = new List();
  Matrix4 transform;

  void addPoint(Offset point) {
    _lines.add(point);
  }

  void paint(Canvas canvas, _) {
    canvas.drawPath(toPath(), _paint);
    canvas.drawPath(toPathC(), _paint);
  }

  Path toPath() {
    final Path p = new Path();
    if (_lines.length == 0) return p;
    Offset p1 = _lines.elementAt(0);
    p.moveTo(p1.dx,p1.dy);
    for (Offset p2 in _lines) {
      p.lineTo(p2.dx,p2.dy);
    }
    return p;
  }

  Path toPathC() {
    final Path p = new Path();
    if (_lines.length == 0) return p;
    Offset p1 = _lines.elementAt(0);
    p1 = MatrixUtils.transformPoint(transform, p1);
    p.moveTo(p1.dx,p1.dy);
    for (Offset p2 in _lines) { // TODO reverse
      p2 = MatrixUtils.transformPoint(transform, p2);
      p.lineTo(p2.dx,p2.dy);
    }
    return p;
  }
}


class RenderLines extends RenderConstrainedBox {
  RenderLines() : super(additionalConstraints: const BoxConstraints.expand());
  @override bool hitTestSelf(Offset position) => true;

  final Map<int,TessellationLine> _lines = <int,TessellationLine>{};

  @override void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      if (_lines.length==0) {
        final Matrix4 T = new Matrix4.translationValues(100.0,100.0,0.0);
        _lines[0] = new TessellationLine(T);
      }
      _lines[0].addPoint(event.position);
      markNeedsPaint();
    }
  }

  @override void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    canvas.drawRect(offset & size, new Paint()..color = const Color(0xFFFFFFFF));
    for (TessellationLine line in _lines.values) {
      line.paint(canvas, offset);
    }
    super.paint(context, offset);
  }
}

class LinesWidget extends SingleChildRenderObjectWidget {
  const LinesWidget({ Key key, Widget child }) : super(key: key, child: child);
  @override RenderLines createRenderObject(BuildContext context) => new RenderLines();
}
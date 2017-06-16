import 'dart:math';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class TessellationLine {
  TessellationLine();

  final Paint _paint = new Paint()..color = const Color(0xFF00FF00)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;
  Matrix4 transform = new Matrix4.zero();
  double human_angle = 0.0;
  List<Offset> _lines = new List();

  void update(PointerEvent event) {
    addPoint(event.position);
  }

  void addPoint(Offset p) {
    _lines.add(p);
  }

  void paint(Canvas canvas, _) {
    canvas.drawPath(toPath(), _paint);
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
}

class RenderLines extends RenderConstrainedBox {
  RenderLines() : super(additionalConstraints: const BoxConstraints.expand());
  @override bool hitTestSelf(Offset position) => true;

  final Map<int,TessellationLine> _lines = <int,TessellationLine>{};

  @override void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      if (_lines.length==0) {
        _lines[0] = new TessellationLine();
      }
      _lines[0].update(event);
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
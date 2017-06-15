import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class TessellationLine {
  TessellationLine();
    
  final Paint _paint = new Paint()..color = const Color(0xFF00FF00);
  Offset position = Offset.zero;
  double human_angle = 0.0;
  
  void update(PointerEvent event) {
    position = event.position;
    
  }
  
  void paint(Canvas canvas, Offset offset) {
    Offset p = Offset.zero;
    canvas.drawLine(p, position, _paint);
  }
}

class RenderLines extends RenderConstrainedBox {
  RenderLines() : super(additionalConstraints: const BoxConstraints.expand());
  @override bool hitTestSelf(Offset position) => true;

  final Map<int,TessellationLine> _lines = <int,TessellationLine>{};
  
  @override void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      _lines[event.pointer] = new TessellationLine()..update(event);      
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
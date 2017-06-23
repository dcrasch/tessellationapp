import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';

import 'tessellationfigure.dart';

class RenderLines extends RenderConstrainedBox {
  RenderLines(this.figure) : super(additionalConstraints: const BoxConstraints.expand());

  TessellationFigure figure;

  @override bool hitTestSelf(Offset position) => true;

  @override void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    print(PointerEvent);
    if (event is PointerDownEvent) {
      // todo stuff
      markNeedsPaint();
      
    }
  }
  
  @override void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    canvas.drawRect(offset & size, new Paint()..color = const Color(0xFFFFFFFF));
    if (figure != null) {
      figure.paint(canvas, offset);
    }
    super.paint(context, offset);
  }
}


class LinesWidget extends SingleChildRenderObjectWidget {
  TessellationFigure figure;
  LinesWidget({ Key key, Widget child, this.figure }) : super(key: key, child: child);
  @override RenderLines createRenderObject(BuildContext context) => new RenderLines(figure);
}
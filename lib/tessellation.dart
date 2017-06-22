import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';

import 'tessellationfigure.dart';

class RenderLines extends RenderConstrainedBox {
  RenderLines() : super(additionalConstraints: const BoxConstraints.expand());

  final TessellationFigure _figure = new TessellationFigure()..initWithSquare();

  @override bool hitTestSelf(Offset position) => true;

  @override void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    print(PointerEvent);
    if (event is PointerDownEvent) {
      // todo stuff
      print(event.position);
      markNeedsPaint();
    }
  }

  @override void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    canvas.drawRect(offset & size, new Paint()..color = const Color(0xFFFFFFFF));
    print(_figure);
    _figure.paint(canvas, offset);
    super.paint(context, offset);
  }

}


class LinesWidget extends SingleChildRenderObjectWidget {
  const LinesWidget({ Key key, Widget child }) :
    super(key: key, child: child);

  @override RenderLines createRenderObject(BuildContext context) => new RenderLines();
}
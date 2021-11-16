import 'package:flutter/widgets.dart';

import 'tessellationfigure.dart';

class TessellationTiledPainter extends CustomPainter {
  final TessellationFigure figure;
  final double dscale;
  TessellationTiledPainter(this.figure, this.dscale);

  @override
  void paint(Canvas canvas, Size size) {
    figure.tessellate(
        canvas,
        new Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero)),
        dscale);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class TessellationTiled extends StatelessWidget {
  TessellationTiled({Key key, this.figure}) : super(key: key);
  final TessellationFigure figure;

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
        child: new Container(),
        isComplex: true,
        painter: new TessellationTiledPainter(figure, 50.0));
  }
}

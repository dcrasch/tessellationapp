import 'dart:ui' as ui;

class SweepGradient extends Gradient {
  const SweepGradient(this.center, this.colors);

  final Offset center;
  final List<Color> colors;

  @override
  Shader createShader(Rect rect) {
    return new ui.Gradient.sweep(center, colors);
  }
}

/*new Center(
    child: new ConstrainedBox(
        constraints: new BoxConstraints.expand(),
        child: new DecoratedBox(
            decoration: new BoxDecoration(
                gradient: new SweepGradient(
                    new Offset(300.0,200.0),
                    <Color>[Colors.cyan,const Color(0xFFFF00FF),
                      Colors.yellow, Colors.cyan]
                                          ))))),
*/

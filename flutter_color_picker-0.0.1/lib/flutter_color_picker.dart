library flutter_color_picker;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ColorTile extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;
  final bool rounded;
  final bool check;
  final double size;

  ColorTile(
      {@required this.color,
      this.onTap,
      this.size = 70.0,
      this.rounded = false,
      this.check = false});

  @override
  Widget build(BuildContext context) {
    var body;
    if (rounded == true) {
      body = new Container(
          height: size,
          width: size,
          margin: const EdgeInsets.all(4.0),
          decoration: new BoxDecoration(color: color, shape: BoxShape.circle));
    } else {
      body = new Container(height: size, width: size, color: color);
    }

    if (check) {
      body = new Stack(
          alignment: FractionalOffset.center,
          children: <Widget>[body, new Icon(Icons.done, color: Colors.white)]);
    }

    return new GestureDetector(onTap: onTap, child: body);
  }
}

class ColorPickerGrid extends StatelessWidget {
  final ValueChanged<Color> onTap;
  final bool rounded;
  final Color selected;
  final List<Color> colors;

  ColorPickerGrid(
      {@required this.colors,
      @required this.onTap,
      this.rounded = false,
      this.selected});

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final rows = _buildColorRows(colors, onTap,
        rounded: rounded,
        sizeRow: orientation == Orientation.portrait ? 4 : 6,
        selected: selected);

    return new Column(children: rows);
  }

  _buildColorRows(List<Color> colors, ValueChanged<Color> onTap,
      {int sizeRow: 4, bool rounded = false, Color selected}) {
    final rows = [];
    int count = 0;
    var row;
    for (Color color in colors) {
      if (count % sizeRow == 0) {
        if (row != null) {
          rows.add(new Row(
              children: row, mainAxisAlignment: MainAxisAlignment.center));
        }
        row = [];
      }
      row.add(new ColorTile(
          color: color,
          onTap: () {
            onTap(color);
          },
          rounded: rounded,
          check: selected == color));
      count++;
    }

    if (row?.isNotEmpty == true) {
      rows.add(new Row(
          children: row,
          mainAxisAlignment: row.length == sizeRow
              ? MainAxisAlignment.center
              : MainAxisAlignment.start));
    }
    return rows;
  }
}

class PrimaryColorPickerGrid extends ColorPickerGrid {
  PrimaryColorPickerGrid(
      {@required ValueChanged<Color> onTap, bool rounded, Color selected})
      : super(
            colors: Colors.primaries,
            onTap: onTap,
            rounded: rounded,
            selected: selected);
}

class AccentColorPickerGrid extends ColorPickerGrid {
  AccentColorPickerGrid(
      {@required ValueChanged<Color> onTap, bool rounded, Color selected})
      : super(
            colors: Colors.accents,
            onTap: onTap,
            rounded: rounded,
            selected: selected);
}

class CompleteColorPickerGrid extends ColorPickerGrid {
  CompleteColorPickerGrid(
      {@required ValueChanged<Color> onTap, bool rounded, Color selected})
    :super(
        colors: const <Color>[
          Colors.red,          Colors.pink,          Colors.purple,
          Colors.deepPurple,   Colors.indigo,        Colors.blue,
          Colors.lightBlue,    Colors.cyan,          Colors.teal,
          Colors.green,        Colors.lightGreen,    Colors.lime,
          Colors.yellow,       Colors.amber,         Colors.orange,
          Colors.deepOrange,   Colors.grey,          Colors.blueGrey,
          Colors.white,        Colors.black],
        onTap: onTap,
        rounded: rounded,
        selected: selected);
}

class ColorPickerDialog extends StatelessWidget {
  final Widget title;
  final Widget body;

  ColorPickerDialog({this.title, this.body});

  @override
  Widget build(BuildContext context) {
    var children = [];

    if (title != null) {
      children.add(new Container(
          padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 24.0),
          child: new DefaultTextStyle(
              style: Theme.of(context).textTheme.title, child: title),
          alignment: FractionalOffset.center));
    }
    children.add(body);
    return new Dialog(
        child: new IntrinsicWidth(
            stepWidth: 10.0,
            child: new ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 280.0),
                child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children))));
  }
}

class PrimaryColorPickerDialog extends StatelessWidget {
  final bool rounded;
  final Color selected;

  PrimaryColorPickerDialog({this.rounded, this.selected});

  @override
  Widget build(BuildContext context) {
    return new ColorPickerDialog(
        body: new PrimaryColorPickerGrid(
            onTap: (Color color) {
              Navigator.pop(context, color);
            },
            rounded: rounded,
            selected: selected)
                                 );
  }
}

class AccentColorPickerDialog extends StatelessWidget {
  final bool rounded;
  final Color selected;

  AccentColorPickerDialog({this.rounded, this.selected});

  @override
  Widget build(BuildContext context) {
    return new ColorPickerDialog(
        body: new AccentColorPickerGrid(
            onTap: (Color color) {
              Navigator.pop(context, color);
            },
            rounded: rounded,
            selected: selected)
        );
  }
}

class CompleteColorPickerDialog extends StatelessWidget {
  final bool rounded;
  final Color selected;

  CompleteColorPickerDialog({this.rounded, this.selected});

  @override
  Widget build(BuildContext context) {
    return new ColorPickerDialog(
        body: new CompleteColorPickerGrid(
            onTap: (Color color) {
              Navigator.pop(context, color);
            },
            rounded: rounded,
            selected: selected)
        );
  }
}

//Future<Image>wheelImage() {
//  return ///
//}

//class ColorWheelPainter extends CustomPainter {
//  @override void paint(Canvas canvas, Size size) {
//    canvas.drawImage(wheelImage, new Offset(0.0,0.0),

class ColorWheel extends StatelessWidget {
  final ValueChanged<Color> onTap;
  final Color selected;
  
  ColorWheel(
      {@required this.onTap,
       this.selected});
  
  @override
  Widget build(BuildContext context) {
    return new Text("ColorWheel");
  }
}

class ColorWheelDialog extends StatelessWidget {
  final Color selected;
  
  ColorWheelDialog({this.selected});

  @override
  Widget build(BuildContext context) {
    return new ColorPickerDialog(
        body: new ColorWheel(
            onTap: (Color color) {
          Navigator.pop(context, color);
        },
            selected: selected));
  }
}
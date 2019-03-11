import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TessellationColor extends StatefulWidget {
  Color currentColor;
  TessellationColor(this.currentColor);

  @override
  State<StatefulWidget> createState() => new _TessellationColorState();
}

class _TessellationColorState extends State<TessellationColor> {
  Color pickerColor = new Color(0xff443a49);
  //TessellationColorPickerDialog({this.pickerColor});

  ValueChanged<Color> onColorChanged;

  @override
  void initState() {
    super.initState();
    setState(() {
        pickerColor = widget.currentColor;
    });
  }

  changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: const Text('Pick a color!'),
      content: new SingleChildScrollView(
          child: new ColorPicker(
        pickerColor: pickerColor,
        onColorChanged: changeColor,
        colorPickerWidth: 1000.0,
        pickerAreaHeightPercent: 0.7,
      )),
      actions: <Widget>[
        new FlatButton(
          child: new Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(pickerColor);
          },
        ),
      ],
    );
  }
}

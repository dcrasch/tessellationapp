import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TessellationColor extends StatefulWidget {
  TessellationColor(this.currentColor);
  final Color? currentColor;

  @override
  State<StatefulWidget> createState() => new _TessellationColorState();
}

class _TessellationColorState extends State<TessellationColor> {
  Color? pickerColor = new Color(0xff443a49);

  ValueChanged<Color>? onColorChanged;

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
          child: new MaterialPicker(
        pickerColor: pickerColor!,
        onColorChanged: changeColor,
      )),
      actions: <Widget>[
        new TextButton(
          child: new Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(pickerColor);
          },
        ),
      ],
    );
  }
}

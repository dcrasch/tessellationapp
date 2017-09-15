import 'package:flutter/material.dart';
import 'package:flutter_color_picker/flutter_color_picker.dart';

class TessellationColorPickerGrid extends ColorPickerGrid {
  TessellationColorPickerGrid(
      {@required ValueChanged<Color> onTap, bool rounded, Color selected})
      : super(
            colors: const <Color>[
              Colors.red,
              Colors.redAccent,
              Colors.pink,
              Colors.purple,
              Colors.deepPurple,
              Colors.indigo,
              Colors.blue,
              Colors.blueAccent,
              Colors.lightBlue,
              Colors.cyan,
              Colors.teal,
              Colors.green,
              Colors.greenAccent,
              Colors.lightGreen,
              Colors.lime,
              Colors.yellow,
              Colors.amber,
              Colors.orange,
              Colors.deepOrange,
              Colors.brown,
              Colors.grey,
              Colors.blueGrey,
              Colors.white,
              Colors.black],            
            onTap: onTap,
            rounded: rounded,
            selected: selected);
}

class TessellationColorPickerDialog extends StatelessWidget {
  final bool rounded;
  final Color selected;

  TessellationColorPickerDialog({this.rounded, this.selected});

  @override
  Widget build(BuildContext context) {
    return new ColorPickerDialog(
        body: new TessellationColorPickerGrid(
            onTap: (Color color) {
              Navigator.pop(context, color);
            },
            rounded: rounded,
            selected: selected));
  }
}
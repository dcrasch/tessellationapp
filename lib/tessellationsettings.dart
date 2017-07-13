import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_color_picker/flutter_color_picker.dart';

import 'tessellationfigure.dart';

class FigureSettings extends StatefulWidget {
  FigureSettings({Key key, this.figure}) : super(key: key);

  TessellationFigure figure;

  @override
  _FigureSettingsState createState() => new _FigureSettingsState();
}

class _FigureSettingsState extends State<FigureSettings> {
  Color _color;

  void initState() {
    super.initState();
    setState(() {
      _color = const Color(0xFFFF0000);
    });
  }

  Widget _buildColorTile(String text, Color color, VoidCallback onTap) {
    return new ListTile(
        title: new Row(children: [
          new Expanded(child: new Text(text)),
          new Padding(
              padding: new EdgeInsets.only(right: 14.0),
              child: new ColorTile(color: color, size: 40.0, rounded: true)),
        ]),
        onTap: onTap);
  }

  @override
  Widget build(BuildContext context) {
    var children = [
      _buildColorTile("primary color", _color, () async {
        Color c = await showDialog(
            context: context, child: new PrimaryColorPickerDialog());
        setState(() {
          widget.figure.colors[0] = c;
          _color = c;
        });
      })
    ];

    return new Scaffold(
        appBar:
            new AppBar(title: const Text('Tessellation'), actions: <Widget>[]),
        body: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children));
  }
}

import 'package:flutter/material.dart';
import 'colorpicker.dart';

class FigureSettings extends StatefulWidget {
  FigureSettings({Key key, this.colors, this.description}) : super(key: key);

  List<Color> colors;
  String description;

  @override
  _FigureSettingsState createState() => new _FigureSettingsState();
}

class _FigureSettingsState extends State<FigureSettings> {
  List<Color> _colors = new List<Color>(4);
  String _description = "";
  final TextEditingController _descriptionController =
      new TextEditingController();

  void initState() {
    super.initState();
    setState(() {
      _description = widget.description;
      _descriptionController.text = _description;
      _colors = widget.colors;
    });
  }

  Widget _buildColorTile(String text, Color color, VoidCallback onTap) {
    return new ListTile(
        title: new Row(children: [
          //new Expanded(child: new Text(text)),
          new Padding(
              padding: new EdgeInsets.only(right: 14.0),
              child: new Container(
                  height: 70.0,
                  width: 70.0,
                  margin: const EdgeInsets.all(4.0),
                  decoration:
                      new BoxDecoration(color: color, shape: BoxShape.circle))),
        ]),
        onTap: onTap);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      new TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            hintText: 'Description',
          ))
    ];
    for (int i = 0; i < _colors.length; i++) {
      children.add(_buildColorTile("$i", _colors[i], () async {
        Color c = await showDialog(
            context: context,
            builder: (BuildContext _) => new TessellationColor());
        setState(() {
          _colors[i] = c;
        });
      }));
    }
    children.add(new FlatButton(
        child: const Text("Apply"),
        onPressed: () {
          Navigator.pop(context,
              {'colors': _colors, 'description': _descriptionController.text});
        }));

    return new Scaffold(
        appBar:
            new AppBar(title: const Text('Tessellation'), actions: <Widget>[]),
        body: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children));
  }
}

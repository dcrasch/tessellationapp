import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

import 'tessellationeditor.dart';
import 'tessellationcreate.dart';
import 'tessellationfigure.dart';

class TessellationList extends StatefulWidget {
  const TessellationList({Key key}) : super(key: key);

  static const String routeName = '/material/list';

  @override
  _TessellationListState createState() => new _TessellationListState();
}

class _TessellationListState extends State<TessellationList> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  List<TessellationFigure> items = <TessellationFigure>[];

  @override
  void initState() {
    super.initState();
    _getItems().then((List<TessellationFigure> l) {
      setState(() {
        items = l;
      });
    });
  }

  void showFigure(BuildContext context, TessellationFigure f) {
    Navigator.push(context,
        new MaterialPageRoute<Null>(builder: (BuildContext context) {
      return new FigurePage(figure: f);
    }));
  }

  Future<List<TessellationFigure>> _getItems() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    List<TessellationFigure> myitems = <TessellationFigure>[];
    for (FileSystemEntity file in appDir.listSync(recursive: false)) {
      // TODO skip failed
      if (file.path.endsWith('.json')) {
        String code = await file.readAsString();
        final JsonDecoder decoder = new JsonDecoder();
        final Map<String, dynamic> result = decoder.convert(code);
        try {
          TessellationFigure f = new TessellationFigure.fromJson(result);
          myitems.add(f);
        } catch (e) {
          print(e);
        }
      }
    }
    return myitems;
  }

  Widget buildListTile(BuildContext context, TessellationFigure f) {
    if (f != null) {
      return new ListTile(
          title: new Text('${f.description}.'),
          onTap: () {
            showFigure(context, f);
          });
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> listTiles =
        items.map((TessellationFigure item) => buildListTile(context, item));

    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Figure List'),
      ),
      body: new Scrollbar(
        child: new ListView(
          padding: new EdgeInsets.symmetric(vertical: 4.0),
          children: listTiles.toList(),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog<String>(
                context: context,
                child: new TessellationCreate()).then((TessellationFigure f) {
              if (f != null) {
                setState(() {
                  items.add(f);
                });
                showFigure(context, f);
              }
            });
          }),
    );
  }
}

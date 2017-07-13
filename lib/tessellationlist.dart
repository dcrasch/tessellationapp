import 'dart:async';
import 'dart:io';

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
      return new FigurePage(figure:f);
    }));
  }

  Future<List<String>> _getItems() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    List<TessellationFigure> myitems = <TessellationFigure>[];
    for (FileSystemEntity file in appDir.listSync(recursive: true)) {
      //final String code = await bundle.loadString(file.path) ?? "failed";
      //final JsonDecoder decoder = new JsonDecoder();    
      //final Map<String, dynamic> result = decoder.convert(code);
      //return new TessellationFigure.fromJson(result);
      //myitems.add(await);
    }
    return myitems;
  }

  Future<Null> _createFigure(String figurename) async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String guid = new DateTime.now().format();
    String filename = "${appDir}/${guid}.json";
    final String code =
        await bundle.loadString('lib/${figurename}.json') ?? "failed";
    await (new File(filename).writeAsString(code));
  }

  Widget buildListTile(BuildContext context, TessellationFigure f) {
    return new ListTile(
        title: new Text('${f.description}.'),
        onTap: () {
          showFigure(context, f);
        });
  }

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> listTiles =
        items.map((TessellationFigure item) => buildListTile(context, item));

    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Figure List'),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add',
              onPressed: () {
                showDialog<String>(
                    context: context,
                    child: new TessellationCreate()).then((TessellationFigure f) {
                      showFigure(context,f);
                });
              }),
          new PopupMenuButton<String>(
              onSelected: (String value) {
                print(value);
              },
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                    const PopupMenuItem<String>(
                        value: 'Export SVG', child: const Text('Export SVG')),
                    const PopupMenuItem<String>(
                        value: 'Share', child: const Text('Share')),
                  ]),
        ],
      ),
      body: new Scrollbar(
        child: new ListView(
          padding: new EdgeInsets.symmetric(vertical: 4.0),
          children: listTiles.toList(),
        ),
      ),
    );
  }
}

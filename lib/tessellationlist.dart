import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'tessellationeditor.dart';
import 'tessellationcreate.dart';

class ListDemo extends StatefulWidget {
  const ListDemo({Key key}) : super(key: key);

  static const String routeName = '/material/list';

  @override
  _ListDemoState createState() => new _ListDemoState();
}

class _ListDemoState extends State<ListDemo> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  List<String> items = <String>[];

  @override
  void initState() {
    super.initState();

    _getItems().then((List<String> l) {
      setState(() {
        items = l;
      });
    });
  }

  void showFigure(BuildContext context, String filename) {
    Navigator.push(context,
        new MaterialPageRoute<Null>(builder: (BuildContext context) {
      return new MyHomePage(title: filename);
    }));
  }

  Future<List<String>> _getItems() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    List<String> myitems = <String>[];
    for (FileSystemEntity file in appDir.listSync(recursive: true)) {
      myitems.add(file.path);
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

  Widget buildListTile(BuildContext context, String item) {
    return new ListTile(
        title: new Text('This item represents $item.'),
        onTap: () {
          showFigure(context, item);
        });
  }

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> listTiles =
        items.map((String item) => buildListTile(context, item));

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
                    child: new TessellationCreate()).then((String x) {
                  print(x);
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

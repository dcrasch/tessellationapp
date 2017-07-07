// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

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

    //_getItems().then((List<String> l) {
    //  setState(() {
    //    items = l;
    //  });
    //});
    getApplicationDocumentsDirectory().then((Directory d) {
      print(d.path);
      setState(() {
        items = [];
      });
    });
  }

  Future<List<String>> _getItems() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    List<String> myitems = <String>[];
    for (FileSystemEntity file in appDir.listSync(recursive: true)) {
      myitems.add(file.path);
    }
    return myitems;
  }

  Widget buildListTile(BuildContext context, String item) {
    return new ListTile(
      title: new Text('This item represents $item.'),
                        );
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
            //
              }
          ),
          new IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Show menu',
//            onPressed: _bottomSheet == null ? _showConfigurationSheet : null,
          ),
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

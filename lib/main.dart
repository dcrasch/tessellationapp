import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

import 'tessellation.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
    Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Tessellation App',
        theme: new ThemeData(
            primarySwatch: Colors.blue,
                             ),
        home: new MyHomePage(title: 'Tessellation'),
                           );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
    _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Directory> _appDocumentsDirectory;
  Future<String> _getSquare(AssetBundle bundle) async {
    final String code = await bundle.loadString('lib/square.json') ?? "failed";
    return code;
  }

  @override Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: const Text('Tessellation')),
        body: new Center(
            child: new FutureBuilder<String>(
                future:  _getSquare(DefaultAssetBundle.of(context)),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return new Text('path: ${snapshot.data}');
              } else {
                return const Text('You have not yet pressed the button');
              }
            })),
        floatingActionButton: new FloatingActionButton(
            onPressed: () {
          setState(() {
            _appDocumentsDirectory = getApplicationDocumentsDirectory();
          });
        },
            tooltip: '',
            child: const Text('+')
                                                       ),
                        );
  }
}

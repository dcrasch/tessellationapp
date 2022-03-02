import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'tessellationfigure.dart';

class TessellationItem extends StatelessWidget {
  const TessellationItem({Key? key, this.figurekey}) : super(key: key);

  final String? figurekey;

  Future<TessellationFigure> _getFigure(String key, AssetBundle bundle) async {
    final String code = await bundle.loadString(key) ?? "failed";
    final JsonDecoder decoder = new JsonDecoder();
    final Map<String, dynamic> result = decoder.convert(code);
    return TessellationFigure.fromJson(result);
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<TessellationFigure>(
        future: _getFigure(figurekey!, DefaultAssetBundle.of(context)),
        builder:
            (BuildContext context, AsyncSnapshot<TessellationFigure> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            TessellationFigure f = snapshot.data!;
            return new SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, f);
              },
              child: new Text(f.description!),
            );
          } else {
            return const Text("failed to load example");
          }
        });
  }
}

class TessellationCreate extends StatelessWidget {
  final List<TessellationItem> _createItems = <TessellationItem>[
    new TessellationItem(figurekey: 'lib/square.json'),
    new TessellationItem(figurekey: 'lib/square90.json'),
    new TessellationItem(figurekey: 'lib/diamond.json'),
    new TessellationItem(figurekey: 'lib/triangle.json'),
    new TessellationItem(figurekey: 'lib/hexagon.json'),
    new TessellationItem(figurekey: 'lib/brick.json')
  ];

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
        title: const Text('Choose figure'), children: _createItems);
  }
}

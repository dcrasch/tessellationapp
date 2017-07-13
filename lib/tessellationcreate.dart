import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'tessellationfigure.dart';

class TessellationItem extends StatelessWidget {
  const TessellationItem({Key key, this.figurekey, this.onPressed }) :
    super(key: key);

  final String figurekey;
  final VoidCallback onPressed;

  Future<TessellationFigure> _getFigure(String key, AssetBundle bundle) async {
    final String code = await bundle.loadString(key) ?? "failed";
    final JsonDecoder decoder = new JsonDecoder();    
    final Map<String, dynamic> result = decoder.convert(code);
    return new TessellationFigure.fromJson(result);
  }
  
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<TessellationFigure>(
        future: _getFigure(figurekey, DefaultAssetBundle.of(context)),
        builder: (BuildContext context,
            AsyncSnapshot<TessellationFigure> snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        TessellationFigure f = snapshot.data;
        return new SimpleDialogOption(
            onPressed: onPressed,
            child: new Text(f.description),
                                      );
      }
      else {
        return const Text("failed to load example");
      }
    });
  }
}     

class TessellationCreate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: const Text('Choose figure'),
      children: <Widget>[
        new TessellationItem(figurekey: 'lib/square.json',
            onPressed: () { Navigator.pop(context, 'lib/square.json');  }
                             ),
        new TessellationItem(figurekey: 'lib/diamond.json',
            onPressed: () { Navigator.pop(context, 'lib/diamond.json');  }
                             ),
      ],
    );
  }
}

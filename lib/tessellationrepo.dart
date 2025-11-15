import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_saver/file_saver.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, ByteData;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tessellation/tessellationfigure.dart';
import 'package:tessellation/tessellationsvg.dart';

class TessellationRepo {
  Future<TessellationFigure> _getFigure(String key, AssetBundle bundle) async {
    final String code = await bundle.loadString(key);
    final JsonDecoder decoder = new JsonDecoder();
    final Map<String, dynamic> result = decoder.convert(code);
    return TessellationFigure.fromJson(result);
  }

  Future<Null> svgToDataUrl(data, figure) async {
    final bool kIsDesktop = (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.fuchsia);
    if (figure!.uuid!.isEmpty) {
      DateTime _nu = new DateTime.now();
      figure!.uuid = _nu.toString();
    }
    String filename = "${figure!.uuid}.svg";
    if (kIsWeb) {
      await FileSaver.instance
          .saveFile(name: filename, bytes: utf8.encode(data));
    } else if (kIsDesktop) {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'images',
        extensions: <String>['svg'],
      );
      final location = await getSaveLocation(
          suggestedName: filename, acceptedTypeGroups: <XTypeGroup>[typeGroup]);
      if (location != null) {
        await FileSaver.instance
            .saveFile(name: filename, bytes: utf8.encode(data));
      }
      return;
    } else {
      await SharePlus.instance.share(ShareParams(
          text: figure!.description,
          files: [
            XFile.fromData(utf8.encode(data),
                name: filename, mimeType: 'image/svg+xml')
          ],
          downloadFallbackEnabled: true));
    }
  }

  Future<Null> _shareFigure(TessellationFigure figure) async {
    final bool kIsDesktop = (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.fuchsia);
    if (figure!.uuid!.isEmpty) {
      DateTime _nu = new DateTime.now();
      figure!.uuid = _nu.toString();
    }
    String filename = "${figure!.uuid}.png";
    final ui.PictureRecorder recorder = new ui.PictureRecorder();
    final ui.Rect paintBounds = new ui.Rect.fromLTRB(0.0, 0.0, 1024.0, 1024.0);
    final ui.Canvas canvas = new ui.Canvas(recorder, paintBounds);
    figure!.tessellate(canvas, paintBounds, 80.0);
    final ui.Image image = await recorder.endRecording().toImage(1024, 1024);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (kIsWeb) {
      await FileSaver.instance
          .saveFile(name: filename, bytes: byteData!.buffer.asUint8List());
    } else if (kIsDesktop) {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'images',
        extensions: <String>['png'],
      );
      final location = await getSaveLocation(
          suggestedName: filename, acceptedTypeGroups: <XTypeGroup>[typeGroup]);
      if (location != null) {
        await FileSaver.instance
            .saveFile(name: filename, bytes: byteData!.buffer.asUint8List());
      }
    } else {
      await SharePlus.instance.share(ShareParams(
          text: figure!.description,
          files: [
            XFile.fromData(byteData!.buffer.asUint8List(),
                name: filename, mimeType: 'image/png')
          ],
          downloadFallbackEnabled: true));
    }
  }

  Future<Null> _exportSVG(TessellationFigure figure) async {
    await svgToDataUrl(TessellationSVG.convert(figure!));
  }

  Future<List<TessellationFigure>> _getStorageItems() async {
    List<TessellationFigure> myitems = <TessellationFigure>[];
    String? figures = localStorage.getItem('figures');
    if (figures == null) {
      return myitems;
    }
    final JsonDecoder decoder = new JsonDecoder();
    final List<dynamic> listresult = decoder.convert(figures);
    for (String figureId in listresult) {
      String? code = localStorage.getItem(figureId);
      if (code == null) {
        continue;
      }
      final JsonDecoder decoder = new JsonDecoder();
      final Map<String, dynamic> result = decoder.convert(code);
      try {
        TessellationFigure f = new TessellationFigure.fromJson(result);
        myitems.add(f);
      } catch (e) {
        //print(e);
      }
    }
    return myitems;
  }

  Future<List<TessellationFigure>> _getItems() async {
    if (kIsWeb) {
      return _getStorageItems();
    }
    Directory appDir = await getApplicationDocumentsDirectory();
    List<TessellationFigure> myitems = <TessellationFigure>[];
    for (FileSystemEntity entity in appDir.listSync(recursive: false)) {
      // TODO skip failed
      if (entity is File && entity.path.endsWith('.json')) {
        String code = entity.readAsStringSync();
        final JsonDecoder decoder = new JsonDecoder();
        final Map<String, dynamic> result = decoder.convert(code);
        try {
          TessellationFigure f = new TessellationFigure.fromJson(result);
          myitems.add(f);
        } catch (e) {
          //print(e);
        }
      }
    }
    return myitems;
  }

  Future<File> _getLocalFile(figure) async {
    // TODO move file stuff to repo
    Directory appDir = await getApplicationDocumentsDirectory();
    String filename = "${appDir.path}/${figure.uuid}.json";
    return new File(filename);
  }

  Future deleteLocalFigure(figure) async {
    final file = await _getLocalFile(figure);
    await file.delete();
  }
}

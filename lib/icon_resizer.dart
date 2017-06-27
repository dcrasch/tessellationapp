library image_resizer;

import 'package:barback/barback.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';


var _tempDir = Directory.systemTemp.createTemp();

Future<List<int>> readAll(Stream<List<int>> data) async => (await data.fold(
        new BytesBuilder(), (BytesBuilder builder, data) => builder..add(data)))
    .takeBytes();

Future<Asset> runInkscape(Asset input) async {
  var dir = await _tempDir;
  var filename = basename(input.id.path);
  var inputfile = new File(join(dir.path, filename));
  var outputfile = new File(join(dir.path, '${filename}.png'));
  await inputfile.writeAsBytes(await readAll(input.read()));
  var args = "${inputfile.path} "
  "-a0:-6.933:320:313.067 "
  "-w167"
  "-h167 "
  "--export-png=${outputfile.path}";

  ProcessResult result = await Process.run(
      "inkscape",
      []..addAll(args.split(' ')));
  if (result.exitCode != 0) {
    throw new ArgumentError('Failed to convert ${input.id}:\n${result.stderr}');
  }
  return new Asset.fromFile(input.id.addExtension('.png'),
      outputfile);
}

class IconResizer extends Transformer {
  IconResizer.asPlugin();

  String get AllowedExtensions => ".svg";

  Future apply(Transform transform) async {
    transform.addOutput(await runInkscape(transform.primaryInput));
  }
}
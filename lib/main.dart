import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'tessellationlist.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(new TessellationApp());
}

class TessellationApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false, // for screenshots
      title: 'Tessellation App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: new TessellationList(),
    );
  }
}

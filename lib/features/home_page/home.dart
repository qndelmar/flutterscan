import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../theme/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  Future<bool> requestPermissions() async {
    const cameraPermission = Permission.camera;
    if (await cameraPermission.isGranted) {
      return true;
    } else {
      final result = cameraPermission.request();
      if (await result.isGranted) {
        return true;
      }
    }

    return false;
  }

  Future<void> _openCamera() async {
    final result = await requestPermissions();
    if (result == true && context.mounted) {
      Navigator.of(context).pushNamed('/scan');
    } else {
      // TODO for permission not granted
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Нажмите на кнопку чтобы получить разрешения и перейти к сканированию', style: dartTheme.textTheme.bodyMedium, textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCamera,
        tooltip: 'Increment',
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
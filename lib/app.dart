import 'package:barcode_reader/router/router.dart';
import 'package:barcode_reader/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class BarcodeReaderApp extends StatelessWidget {
  const BarcodeReaderApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: dartTheme,
      routes: routes,
    );
  }
}



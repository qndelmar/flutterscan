import 'dart:convert';

import 'package:barcode_reader/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';


class NFCInfo extends StatefulWidget {
  const NFCInfo({super.key});

  @override
  State<NFCInfo> createState() => _NFCInfoState();
}

class _NFCInfoState extends State<NFCInfo> {
  NdefMessage? tag;
  String technologies = "";
  @override
  Future<void> didChangeDependencies() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    assert(args != null && args is NdefMessage, 'You must provide args with type BarcodeCapture');
    tag = args as NdefMessage;
    var payload = tag!.records[0].payload;
    var sub = payload.sublist(payload[0]+ 1);
    technologies = String.fromCharCodes(sub);
    setState(() { });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Информация об NFC карты"),),
      body: technologies != ""
          ?
      Center(
        child: Text("Первая запись NDEF: $technologies",
        style: dartTheme.textTheme.bodyMedium,
        textAlign: TextAlign.center,))
          :
      Center(child: Text("Информация о карте не получена верно",
        style: dartTheme.textTheme.bodyMedium,
        textAlign: TextAlign.center,),)
    );
  }
}


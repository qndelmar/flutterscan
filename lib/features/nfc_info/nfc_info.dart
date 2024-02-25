import 'package:barcode_reader/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';


class NFCInfo extends StatefulWidget {
  const NFCInfo({super.key});

  @override
  State<NFCInfo> createState() => _NFCInfoState();
}

class _NFCInfoState extends State<NFCInfo> {
  NfcTag? tag;
  String technologies = "";
  @override
  Future<void> didChangeDependencies() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    assert(args != null && args is NfcTag, 'You must provide args with type BarcodeCapture');
    tag = args as NfcTag;
    for(var i in tag!.data.keys) {
      technologies += "$i, ";
    }
    technologies = _formatStringValue(technologies);
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
        child: Text("Поддерживаются: $technologies",
        style: dartTheme.textTheme.bodyMedium,
        textAlign: TextAlign.center,))
          :
      Center(child: Text("Информация о карте не получена верно",
        style: dartTheme.textTheme.bodyMedium,
        textAlign: TextAlign.center,),)
    );
  }
}

String _formatStringValue(String tech){
  var technologiesArray = tech.split("");
  technologiesArray.removeAt(tech.lastIndexOf(","));
  tech = technologiesArray.join("");
  return tech;
}

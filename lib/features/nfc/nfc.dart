import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';


class NFCScanPage extends StatefulWidget {
  const NFCScanPage({super.key});

  @override
  State<NFCScanPage> createState() => _NFCScanPageState();
}

class _NFCScanPageState extends State<NFCScanPage> {
  String? valueText;

  @override
  void dispose(){
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<bool>(future: NfcManager.instance.isAvailable(), builder: (context, scan) => scan.data != true ?
        const Center(child: Text("Scanning is not available"),) : Center(child: Flex(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton( child: const Text('Tag Read'), onPressed: ()async{
              _showToast("Приложите карту к крышке");
                try {
                    await _readSector(context);
                } catch (_) {
                  _showToast("Тег не поддерживается");
                  return;
                }

            }),
            ElevatedButton(child: const Text('Tag Write'), onPressed: (){
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Запись в NFC...'),
                      content: TextField(
                        onChanged: (value) {
                          setState(() {
                            valueText = value;
                          });
                        },
                        decoration: const InputDecoration(hintText: "Введите значение"),
                      ),
                      actions: <Widget>[
                        MaterialButton(
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          child: const Text('Write'),
                          onPressed: () {
                            _showToast("Приложите карту к крышке");
                            if (valueText?.length != 13) {
                              _showToast("message must contain 13 symbols (numbers or letters)");
                              return;
                            }
                            _writeToMifare(valueText!);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });

            }),
          ],
      ),
      ),
    )));
  }
}

void _showToast(String mesg){
  Fluttertoast.showToast(
    msg: mesg,
    toastLength: Toast.LENGTH_SHORT,
    textColor: Colors.black,
    fontSize: 16,
    backgroundColor: Colors.grey[200],
  );
}

void _writeToMifare(String msg) {
  NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
    MifareClassic? mfare = MifareClassic.from(tag);
    if(mfare == null) {
      return;
    }
    bool isAuth = await _authToMifare(mfare);
    if(isAuth == true) {
      NdefRecord rec = NdefRecord.createText(msg);
      await mfare.writeBlock(blockIndex: 8, data: rec.payload);
    }});
}

Future<bool> _authToMifare(MifareClassic mfare) async {
  var listKeyDefault = [0xD3,0xF7,0xD3,0xF7,0xD3,0xF7];
  var listKeyDefaultB = [0xFF,0xFF,0xFF,0xFF,0xFF,0xFF];
  var dataKeyDefault = Uint8List.fromList(listKeyDefault);
  var dataKeyDefaultB = Uint8List.fromList(listKeyDefaultB);
  bool? isAuth = await mfare.authenticateSectorWithKeyA(sectorIndex: 2, key: dataKeyDefault);
  bool? isAuthB = await mfare.authenticateSectorWithKeyB(sectorIndex: 2, key: dataKeyDefaultB);
  return isAuth == true && isAuthB == true;
}
Future<void> _readSector(BuildContext context) async {
  Uint8List? list;
  NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
    MifareClassic? mfare = MifareClassic.from(tag);
    if(mfare == null) {
      return;
    }
    bool isAuth = await _authToMifare(mfare);
    if(isAuth == true) {
      list = await mfare.readBlock(blockIndex: 8);
      if(!context.mounted || list == null) {
        return;
      }
      // ТОЛЬКО ДЛЯ УНИФИКАЦИИ ФОРМАТА NFCINFO. НЕ ДЛЯ ПРОДАКШЕНА
      NdefMessage msg = NdefMessage(
          [NdefRecord(
              typeNameFormat: NdefTypeNameFormat.unknown,
              type: Uint8List.fromList([]),
              identifier: Uint8List.fromList([]),
              payload: list!)]);
      Navigator.of(context).pushNamed("/nfcInfo", arguments: msg);
    }});
}



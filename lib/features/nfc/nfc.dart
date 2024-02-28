import 'dart:async';

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
            ElevatedButton( child: const Text('Tag Read'), onPressed: (){
              _showToast("Приложите карту к крышке");
              NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
                try {
                  Ndef? ndef = Ndef.from(tag);
                  if (ndef != null) {
                    NdefMessage? msg = await ndef.read();
                    if(context.mounted) {
                      Navigator.of(context).pushNamed("/nfcInfo", arguments: msg);
                    }
                  } else {
                    _showToast("Тег не поддерживается");
                  }
                } catch (_) {
                  _showToast("Тег не поддерживается");
                  return;
                }
              });

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
                            NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
                              Navigator.pop(context);
                              final ndef = Ndef.from(tag);
                              final formattable = NdefFormatable.from(tag);
                              final message = NdefMessage([NdefRecord.createText(valueText!)]);
                              if (ndef != null) {
                                await ndef.write(message);
                              } else if (formattable != null) {
                                await formattable.format(message);
                              }
                            });
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



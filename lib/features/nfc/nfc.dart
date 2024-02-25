import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nfc_manager/nfc_manager.dart';


class NFCScanPage extends StatefulWidget {
  const NFCScanPage({super.key});

  @override
  State<NFCScanPage> createState() => _NFCScanPageState();
}

class _NFCScanPageState extends State<NFCScanPage> {
  String? valueText;

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
              _showToast();
              NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {

                  Navigator.of(context).pushNamed('/nfcInfo', arguments: tag);
                  NfcManager.instance.stopSession();
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
                            _showToast();
                            NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
                              Navigator.pop(context);
                              //TODO WHEN ADDITIONAL INFO
                              NfcManager.instance.stopSession();
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

void _showToast(){
  Fluttertoast.showToast(
    msg: "Приложите карту к крышке телефона",
    toastLength: Toast.LENGTH_SHORT,
    textColor: Colors.black,
    fontSize: 16,
    backgroundColor: Colors.grey[200],
  );
}


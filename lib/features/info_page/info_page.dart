import 'package:barcode_reader/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class InfoPage extends StatefulWidget {


  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();



}

class _InfoPageState extends State<InfoPage> {

  Barcode? info;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    assert(args != null && args is Barcode, 'You must provide args with type BarcodeCapture');
    info = args as Barcode;
    setState(() { });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Информация с QR-кода"),
        leading: IconButton(onPressed: (){
          Navigator.of(context).popAndPushNamed('/scan');
        }, icon: const Icon(Icons.arrow_back_ios, color: Colors.white,), ),
      ),
      body: Center(
        child:
        info == null
            ?
        Text('На qr-коде не была предоставлена информация',style: dartTheme.textTheme.bodyMedium,)
            :
        Column(
          children: [
            Text("Формат кода: ${info!.format.name}", style: dartTheme.textTheme.bodyMedium,),
            Text("Информация с кода: ${info!.rawValue}",style: dartTheme.textTheme.bodyMedium,),
          ],
        ),
      ),
    );
  }
}

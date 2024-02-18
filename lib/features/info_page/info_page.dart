import 'package:barcode_reader/theme/theme.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {


  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();



}

class _InfoPageState extends State<InfoPage> {


  String? info;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    assert(args != null && args is String, 'You must provide string args');
    info = args as String;
    setState(() {
    });
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
        child: Text(info ?? 'На qr-коде не была предоставлена информация',style: dartTheme.textTheme.bodyMedium,),
      ),
    );
  }
}

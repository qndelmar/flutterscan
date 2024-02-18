import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:barcode_reader/features/scan_page/widgets/overlay.dart';
class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {

  MobileScannerController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Сканер QR-кода"),
      ),
      body: MobileScanner(
          controller: controller ?? (controller = MobileScannerController(
            detectionSpeed: DetectionSpeed.normal,
            facing: CameraFacing.back,
            torchEnabled: false,
            detectionTimeoutMs: 2000,
          )),
        onDetect: (capture) {
            setState(() {
              controller?.stop();
            });
            Navigator.of(context).pushNamed('/info', arguments: capture.barcodes[0].rawValue);
        },
        fit: BoxFit.contain,
        scanWindow: Rect.fromCenter(
          center: MediaQuery.of(context).size.center(Offset.zero),
          width: 400,
          height: 400,
        ),
        overlay: const QRScannerOverlay(
         overlayColour: Color.fromARGB(30, 0, 0, 0),
        ),
      ),
      floatingActionButton: IconButton(onPressed: () {
        setState(() {
          controller?.start();
        });
      }, icon: const Icon(Icons.camera_alt, color: Colors.white,),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

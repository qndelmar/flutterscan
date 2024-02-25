import 'package:barcode_reader/features/info_page/info_page.dart';
import 'package:barcode_reader/features/nfc/nfc.dart';
import 'package:barcode_reader/features/nfc_info/nfc_info.dart';
import 'package:barcode_reader/features/scan_page/scan.dart';

import '../features/home_page/home.dart';

final routes = {
  '/': (context) => const HomePage(title: 'BARCODE READER',),
  '/scan': (context) => const ScanPage(),
  '/info': (context) => const InfoPage(),
  '/scanNFC': (context) => const NFCScanPage(),
  '/nfcInfo': (context) => const NFCInfo()
};
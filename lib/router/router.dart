import 'package:barcode_reader/features/info_page/info_page.dart';
import 'package:barcode_reader/features/scan_page/scan.dart';

import '../features/home_page/home.dart';

final routes = {
  '/': (context) => const HomePage(title: 'BARCODE READER',),
  '/scan': (context) => const ScanPage(),
  '/info': (context) => const InfoPage()
};
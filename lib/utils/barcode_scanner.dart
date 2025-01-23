import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

Future<String> scan(BuildContext context) async {
  String? barcode = await SimpleBarcodeScanner.scanBarcode(
    context,
    isShowFlashIcon: true,
    cameraFace: CameraFace.back,
    scanType: ScanType.barcode,
  );

  return barcode ?? '';
}


import 'package:barcode_scanner/barcodeModel.dart';
import 'package:flutter/material.dart';

class ScannedProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(barcodeModel.productBox.get(barcodeModel.scannedCode, defaultValue: Text("No product associated with this barcode"))),
      ),
    );
  }
}
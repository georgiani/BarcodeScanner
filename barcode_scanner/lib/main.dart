import 'package:barcode_scanner/addProduct.dart';
import 'package:barcode_scanner/barcodeModel.dart';
import 'package:barcode_scanner/scannedProduct.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  barcodeModel.productBox = await Hive.openBox("productBox");

  runApp(BarcodeScannerApp());
}

void initHive() async {
  
}

class BarcodeScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    barcodeModel.productBox = Hive.box("productBox");
    barcodeModel.rootCtx = context;
    return MaterialApp(
      routes: {
        "addProduct": (ctx) => AddProduct(),
        "scannedProduct": (ctx) => ScannedProduct(),
      },
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) {
        return Scaffold(
          body: Center(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlineButton(
                    child: Text("Scan"),
                    onPressed: () async {
                      var result = await BarcodeScanner.scan();
                      barcodeModel.scannedCode = result.rawContent;
                      Navigator.of(ctx).pushNamed("scannedProduct");
                    },
                  ),
                  OutlineButton(
                    child: Text("Add Products"),
                    onPressed: () {
                      Navigator.of(ctx).pushNamed("addProduct");
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: Hive.box("productBox").listenable(),
                    builder: (ctx, box, w) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: box.values == null
                              ? 0
                              : box.values.length,
                          itemBuilder: (ctx, idx) {
                            var product = box.getAt(idx);
                            return ListTile(
                              title: Text(product),
                              subtitle:
                                  Text(box.keyAt(idx)),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

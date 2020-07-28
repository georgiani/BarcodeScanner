import 'package:barcode_scanner/addProduct.dart';
import 'package:barcode_scanner/addProductComplete.dart';
import 'package:barcode_scanner/barcodeModel.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  barcodeModel.nameBox = await Hive.openBox("nameBox");
  barcodeModel.listBox = await Hive.openBox("listBox");
  barcodeModel.initQBox = await Hive.openBox("initQBox");

  runApp(BarcodeScannerApp());
}

class BarcodeScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "addProduct": (ctx) => AddProduct(),
        "addProductComplete": (ctx) => AddProductComplete(),
      },
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<BarcodeModel>(
      model: barcodeModel,
      child: ScopedModelDescendant<BarcodeModel>(builder: (ctx, w, m) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: barcodeModel.page,
            onTap: (idx) {
              barcodeModel.switchPage(idx);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.collections_bookmark),
                title: Text("Spazzole"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.photo_album),
                title: Text("Lista codici a bare"),
              ),
            ],
          ),
          body: Builder(
            builder: (ctx) {
              barcodeModel.rootCtx = context;

              return SafeArea(
                bottom: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAddButton(ctx, barcodeModel.page),
                    _buildList(barcodeModel.page),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Future<void> _showDialog() {
    return showDialog(
      context: barcodeModel.rootCtx,
      builder: (ctx) {
        return AlertDialog(
          content: Text("This product already exists in the list."),
          actions: [
            FlatButton(
              child: Center(
                child: Text("OK"),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        );
      },
    );
  }

  Future<bool> _showConfirmDialog() {
    return showDialog(
        context: barcodeModel.rootCtx,
        builder: (ctx) {
          return AlertDialog(
            content: Text(
                "Sei sicuro di voler rimuovere questo prodotto dalla lista?"),
            actions: [
              FlatButton(
                child: Center(
                  child: Text("Yes"),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
              FlatButton(
                child: Center(
                  child: Text("No"),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              )
            ],
          );
        });
  }

  Future<int> _showEditDialog() {
    TextEditingController _newValueController = TextEditingController();

    return showDialog(
        context: barcodeModel.rootCtx,
        builder: (ctx) {
          return AlertDialog(
            content: TextField(
              controller: _newValueController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 15,
                ),
                hintText: "Nuova quantita",
              ),
            ),
            actions: [
              FlatButton(
                child: Center(
                  child: Text("Cambia"),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(int.parse(_newValueController.text));
                },
              )
            ],
          );
        });
  }

  Widget _buildAddButton(ctx, mode) {
    return mode == 0
        ? IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(ctx).pushNamed("addProductComplete");
            },
          )
        : IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () async {
              ScanResult result = await BarcodeScanner.scan();
              barcodeModel.scannedCode = result.rawContent;

              if (barcodeModel.nameBox.containsKey(barcodeModel.scannedCode)) {
                if (barcodeModel.listBox
                    .containsKey(barcodeModel.scannedCode)) {
                  _showDialog();
                } else {
                  barcodeModel.addToListBox(barcodeModel.scannedCode, 1);
                }
              } else {
                Navigator.of(ctx).pushNamed("addProduct");
              }
            },
          );
  }

  Widget _buildTile(Widget w, int idx, int mode) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.delete),
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (dir) => _showConfirmDialog(),
      onDismissed: (dir) => mode == 0
          ? barcodeModel.deleteFronInitQBox(idx)
          : barcodeModel.deleteFromListBox(idx),
      child: w,
    );
  }

  Widget _buildList(mode) {
    if (mode == 0) {
      return Expanded(
        child: ListView.builder(
          itemCount:
              barcodeModel.initQBox.isEmpty ? 0 : barcodeModel.initQBox.length,
          itemBuilder: (ctx, idx) {
            var data = barcodeModel.initQBox.getAt(idx);
            var productName = barcodeModel.initQBox.keyAt(idx);

            return _buildTile(
              ListTile(
                onLongPress: () {
                  _showEditDialog().then((newValue) {
                    if(newValue != null)
                      barcodeModel.modifyInitialQuantity(newValue, idx);
                  });
                },
                isThreeLine: true,
                leading: Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.add_box),
                ),
                onTap: () => barcodeModel.addToInitQBox(
                  productName,
                  data[0],
                  data[1] + 1,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (data[1] != 0)
                      barcodeModel.addToInitQBox(
                        productName,
                        data[0],
                        data[1] - 1,
                      );
                  },
                ),
                title: Text(productName),
                subtitle: Text(
                  "Quantita iniziale: ${data[0]}\nQuantita: ${data[1]}",
                ),
              ),
              idx,
              mode,
            );
          },
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount:
              barcodeModel.listBox.isEmpty ? 0 : barcodeModel.listBox.length,
          itemBuilder: (ctx, idx) {
            var data = barcodeModel.listBox.getAt(idx);
            var productName =
                barcodeModel.nameBox.get(barcodeModel.listBox.keyAt(idx));

            return _buildTile(
              ListTile(
                leading: Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.add_box),
                ),
                onTap: () => barcodeModel.addToListBox(
                    barcodeModel.listBox.keyAt(idx), data + 1),
                trailing: IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (data == 1) {
                      _showConfirmDialog().then((value) {
                        if (value) barcodeModel.deleteFromListBox(idx);
                      });
                    } else {
                      barcodeModel.addToListBox(
                          barcodeModel.listBox.keyAt(idx), data - 1);
                    }
                  },
                ),
                title: Text(productName),
                subtitle: Text(data.toString()),
              ),
              idx,
              mode,
            );
          },
        ),
      );
    }
  }
}

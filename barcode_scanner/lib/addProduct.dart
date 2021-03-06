import 'package:barcode_scanner/barcodeModel.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        maintainBottomViewPadding: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBarcodeText(),
            _buildProductForm(_controller),
            _buildAddButton(context, _controller),
          ],
        ),
      ),
    );
  }

  Widget _buildProductForm(controller) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 15,
          ),
          hintText: "Nome prodotto",
        ),
      ),
    );
  }

  Widget _buildAddButton(context, controller) {
    return OutlineButton(
      child: Text("Add"),
      onPressed: () {
        if (!controller.text.isEmpty && controller.text != null) {
          barcodeModel.addToNameBox(barcodeModel.scannedCode, controller.text);
          barcodeModel.addToListBox(barcodeModel.scannedCode, 1);
          
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget _buildBarcodeText() {
    return Text(
      "Code: ${barcodeModel.scannedCode}",
    );
  }
}

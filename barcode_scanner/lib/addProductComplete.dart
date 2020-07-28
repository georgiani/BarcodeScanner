import 'package:barcode_scanner/barcodeModel.dart';
import 'package:flutter/material.dart';

class AddProductComplete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controllerCode = TextEditingController();
    TextEditingController _controllerInitQ = TextEditingController();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        maintainBottomViewPadding: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInputField(_controllerCode, "Codice"),
            _buildInputField(_controllerInitQ, "Quantita Iniziale"),
            _buildAddButton(context, _controllerCode, _controllerInitQ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(controller, hint) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 15,
          ),
          hintText: hint,
        ),
      ),
    );
  }

  Widget _buildAddButton(context, controllerCode, controllerInit) {
    return OutlineButton(
      child: Text("Add"),
      onPressed: () {
        if (!controllerCode.text.isEmpty && !controllerInit.text.isEmpty && controllerCode.text != null && controllerInit.text != null) {
          barcodeModel.addToInitQBox(controllerCode.text, int.parse(controllerInit.text), int.parse(controllerInit.text)); //same value initially
          Navigator.of(context).pop();
        }
      },
    );
  }
}

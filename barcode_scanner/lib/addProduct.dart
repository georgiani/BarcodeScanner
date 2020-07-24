import 'package:barcode_scanner/barcodeModel.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String nameSaved, barcodeSaved;

    return Scaffold(
      body: Form(
        key: formKey,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintStyle: TextStyle(
                      fontSize: 20,
                    ),
                    hintText: "Barcode",
                  ),
                  validator: (barcode) {
                    if (barcode == "" || barcode == null) {
                      return "Please insert a valid barcode";
                    }
                  },
                  onSaved: (str) {
                    barcodeSaved = str;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintStyle: TextStyle(
                      fontSize: 20,
                    ),
                    hintText: "Product Name",
                  ),
                  validator: (name) {
                    if (name == "" || name == null) {
                      return "Please insert a valid name";
                    }
                  },
                  onSaved: (str) {
                    nameSaved = str;
                  },
                ),
              ),
              OutlineButton(
                child: Text("Add"),
                onPressed: () {
                  formKey.currentState.save();

                  barcodeModel.productBox.put(barcodeSaved, nameSaved);

                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:scoped_model/scoped_model.dart';

class BarcodeModel extends Model {
  BuildContext rootCtx;
  String scannedCode;
  int page = 0;
  Box nameBox;
  Box listBox;
  Box initQBox;

  switchPage(idx) {
    page = idx;
    notifyListeners();
  }

  addToInitQBox(key, initialValue, currentValue) {
    initQBox.put(key, [initialValue, currentValue]);
    notifyListeners();
  }

  addToNameBox(key, name) {
    nameBox.put(key, name);
    notifyListeners();
  }

  addToListBox(key, quantity) {
    listBox.put(key, quantity);
    notifyListeners();
  }

  deleteFromListBox(index) {
    listBox.deleteAt(index);
    notifyListeners();
  }

  deleteFronInitQBox(index) {
    initQBox.deleteAt(index);
    notifyListeners();
  }

  modifyInitialQuantity(val, index) {
    var keyAtIndex = initQBox.keyAt(index);
    initQBox.put(keyAtIndex, [val, initQBox.get(keyAtIndex)[1]]);
    notifyListeners();
  }
}

BarcodeModel barcodeModel = BarcodeModel();
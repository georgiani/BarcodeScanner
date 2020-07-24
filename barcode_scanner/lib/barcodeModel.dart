import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:scoped_model/scoped_model.dart';

class BarcodeModel extends Model {
  BuildContext rootCtx;
  String scannedCode;
  Box productBox;
}

BarcodeModel barcodeModel = BarcodeModel();
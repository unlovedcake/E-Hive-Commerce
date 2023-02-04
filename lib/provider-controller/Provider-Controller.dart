import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderController extends ChangeNotifier {
  String productCode = "";
  String amount = "";

  setProductCode(String code, String amnt) {
    productCode = code;
    amount = amnt;
    notifyListeners();
  }

  String get getProductCode => productCode;
  String get getAmount => amount;
}

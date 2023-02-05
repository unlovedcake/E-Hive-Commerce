import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderController extends ChangeNotifier {
  int itemCountCart = 0;

  var quantities = ValueNotifier<List<int>?>([0]);

  setQuantities(int count) {
    quantities.value = List.filled(count, 0);
    notifyListeners();
  }

  setItemCountCart(int count) {
    itemCountCart = count;
    notifyListeners();
  }

  int get getItemCountCart => itemCountCart;
  ValueNotifier<List<int>?> get getQuantities => quantities;
}

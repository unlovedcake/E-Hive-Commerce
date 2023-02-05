import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderController extends ChangeNotifier {
  int itemCountCart = 0;

  setItemCountCart(int count) {
    itemCountCart = count;
    notifyListeners();
  }

  int get getItemCountCart => itemCountCart;
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderController extends ChangeNotifier {
  int itemCountCart = 0;

  List<Map<String, dynamic>> itemz = [];
  List<int> quantities = [];

  setListItems(List<Map<String, dynamic>> list) {
    itemz = list;
    notifyListeners();
  }

  void addItemAtIndex(int index, int item) {
    quantities[index] = item;

    print(quantities[index].toString());
    notifyListeners();
  }

  List<Map<String, dynamic>> get getListItems => itemz;

  setQuantities(List<int> list) {
    quantities = list;
    notifyListeners();
  }

  List<int> get getQuantities => quantities;

  setItemCountCart(int count) {
    itemCountCart = count;
    notifyListeners();
  }

  //int get getItemCountCart => itemCountCart;
  //ValueNotifier<List<int>?> get getQuantities => quantities;
}

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

  List<Map<String, dynamic>> get getListItems => itemz;

  setQuantities(List<int> list) {
    quantities = list;
    notifyListeners();
  }

  List<int> get getItemCountCart => quantities;

  setItemCountCart(int count) {
    itemCountCart = count;
    notifyListeners();
  }

  //int get getItemCountCart => itemCountCart;
  //ValueNotifier<List<int>?> get getQuantities => quantities;
}

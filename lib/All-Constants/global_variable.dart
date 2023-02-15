import 'package:adopt_a_pet/model/product-model.dart';
import 'package:flutter/cupertino.dart';

import '../model/user-model.dart';

UserModel? userLoggedIn;

var countAddToCartItem = ValueNotifier<int>(0);
var quantities = ValueNotifier<List<int>?>([0]);
var countBuyItem = ValueNotifier<int>(0);
var itm = ValueNotifier<List<String>?>([]);
var qty = ValueNotifier<int>(0);
var items = ValueNotifier<List<Map<String, dynamic>>>([]);
var dataProduct = ValueNotifier<List<ProductModel>?>([]);
var productItems = ValueNotifier<List<ProductModel>?>([]);

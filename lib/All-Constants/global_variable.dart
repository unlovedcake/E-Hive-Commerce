import 'package:flutter/cupertino.dart';

import '../model/user-model.dart';

UserModel? userLoggedIn;

var countAddToCartItem = ValueNotifier<int>(0);
var quantities = ValueNotifier<List<int>?>([0]);
var items = ValueNotifier<List<Map<String, dynamic>>>([]);

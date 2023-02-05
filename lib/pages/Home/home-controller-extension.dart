part of 'home-screen.dart';

extension ExtensionSigninController on HomeScreenState {
  void goToSingInScreen() {
    Navigator.of(context).push(pageRouteAnimate(const SignInScreen()));
  }

  void countAddItemToCart() {
    countAddToCartItem.value = quantities.value!.reduce((value, element) => value + element);
  }

  void scrollLimit() {
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent && !isLoading.value) {
        setState(() {});

        if (addLimitTenItem.value < _data.value!.length) {
          _fetchDataProduct();
          addLimitTenItem.value += 10;
          isLoading.value = true;
        }
      } else {
        isLoading.value = false;
      }
    });
  }

  Future<void> _fetchDataProduct() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products'));
    if (response.statusCode == 200) {
      setState(() {
        final jsonData = json.decode((response.body));

        ProductListModel? decodedData = ProductListModel.fromMap(jsonData);

        debugPrint(decodedData.limit.toString());

        qty.value = decodedData.limit ?? 0;
        debugPrint("LIMIT");

        // List<ProductModel> decodedData =
        //     (jsonData['products'] as List).map((value) => ProductModel.fromJson(value)).toList();

        _data.value = decodedData.productData;
        // _data = decodedData.productData
        //     ?.sublist(0, dataLenght.value)
        //     .map(
        //       (value) => ProductModel(
        //           id: value.id,
        //           title: value.title,
        //           description: value.description,
        //           price: value.price,
        //           discountPercentage: value.discountPercentage,
        //           rating: value.rating,
        //           stock: value.stock,
        //           brand: value.brand,
        //           category: value.category,
        //           thumbnail: value.thumbnail),
        //     )
        //     .toList();

        searchData = _data.value!;

        isLoading.value = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void sendPushMessage(String token, String title, String body) async {
    try {
      print("oks");
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAATnXoTE:APA91bGIfAlscZmvum3ekOemsEf432MJHESLlKt5RIlTWCgxwC_SuDN6qOWNaMQXejRlE81Nv7MRMgZi9Wf-uO0EkyT-1hJSZyA2V7nlOTeNCXsXJ-XVaE3FiEQDStRSJpJW1LIJT68I',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  void _searchFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      _fetchDataProduct();
    } else {
      _data.value = searchData!
          .where((product) => product.title!.toUpperCase().contains(enteredKeyword.toUpperCase()))
          .toList();
    }
  }
}

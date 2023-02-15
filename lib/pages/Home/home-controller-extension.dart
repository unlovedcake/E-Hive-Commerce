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

        if (addLimitTenItem.value < dataProduct.value!.length) {
          //_fetchDataProduct();
          fetch();
          addLimitTenItem.value += 10;
          isLoading.value = true;
        }
      } else {
        isLoading.value = false;
      }
    });
  }

  fetch() async {
    final repository = Repository(dataSource: NetworkDataSource());
    final datas = await repository.fetchData();

    setState(() {});
    qty.value = 30;
    dataProduct.value = datas.productList;

    fetchings();
  }

  // Future<ApiResponse> _fetchDataProduct() async {
  //   ApiResponse apiResponse = ApiResponse();
  //   final response = await http.get(Uri.parse('https://dummyjson.com/products'));
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       final jsonData = json.decode((response.body));
  //
  //       ProductListModel? decodedData = ProductListModel.fromMap(jsonData);
  //
  //       debugPrint(decodedData.limit.toString());
  //
  //       qty.value = decodedData.limit ?? 0;
  //       debugPrint("LIMIT");
  //
  //       Provider.of<ProviderController>(context, listen: false)
  //           .setQuantities(List.generate(decodedData.limit ?? 0, (_) => 0));
  //
  //       // List<ProductModel> decodedData =
  //       //     (jsonData['products'] as List).map((value) => ProductModel.fromJson(value)).toList();
  //
  //       dataProduct.value = decodedData.productData;
  //
  //       productItems.value = dataProduct.value;
  //       // _data = decodedData.productData
  //       //     ?.sublist(0, dataLenght.value)
  //       //     .map(
  //       //       (value) => ProductModel(
  //       //           id: value.id,
  //       //           title: value.title,
  //       //           description: value.description,
  //       //           price: value.price,
  //       //           discountPercentage: value.discountPercentage,
  //       //           rating: value.rating,
  //       //           stock: value.stock,
  //       //           brand: value.brand,
  //       //           category: value.category,
  //       //           thumbnail: value.thumbnail),
  //       //     )
  //       //     .toList();
  //
  //       searchData = dataProduct.value!;
  //
  //       isLoading.value = false;
  //     });
  //   } else {
  //     apiResponse.error = jsonDecode(response.body)['message'];
  //     throw Exception('Failed to load data');
  //   }
  //
  //   return apiResponse;
  // }

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
      // _fetchDataProduct();
      fetchings();
    } else {
      searchData = dataProducts.value!
          .where((product) => product.title!.toUpperCase().contains(enteredKeyword.toUpperCase()))
          .toList();
      if (searchData!.isNotEmpty) {
        dataProducts.value = searchData;
      }
    }
  }
}

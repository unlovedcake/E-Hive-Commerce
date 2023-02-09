import 'dart:convert';
import 'package:adopt_a_pet/pages/Home/check-out-screen.dart';
import 'package:adopt_a_pet/pages/Home/selected-item-screen.dart';
import 'package:adopt_a_pet/provider-controller/Provider-Controller.dart';
import 'package:adopt_a_pet/widgets/cache-network-image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:adopt_a_pet/pages/SignIn-SignUp/signin-screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';
import '../../All-Constants/color_constants.dart';
import '../../All-Constants/global_variable.dart';
import '../../model/product-model.dart';
import '../../router/Navigate-Route.dart';
import '../../utilities/AssetStorageImage.dart';
import '../../widgets/Toast-Message.dart';

part 'home-controller-extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  //List<ProductModel>? _data = [];
  List<ProductModel>? searchData = [];

  final ScrollController _controller = ScrollController();
  var isLoading = ValueNotifier<bool>(false);
  var addLimitTenItem = ValueNotifier<int>(10);
  var countBuyItem = ValueNotifier<int>(0);

  TextEditingController searchController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String highLightSearchtTerm = "";

  late AnimationController _animateController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animateController);

    _fetchDataProduct();
    scrollLimit();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //quantities.value = List.filled(qty.value, 0);
    productItems.value = List.filled(
        qty.value,
        ProductModel(
          id: 0,
          title: '',
          description: '',
          price: 0.0,
          discountPercentage: 0.0,
          rating: 0.0,
          stock: 0,
          brand: '',
          category: '',
          qty: 0,
          thumbnail: '',
        ));

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'E-Hive',
          style: TextStyle(
            color: AppColors.logoColor,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          ValueListenableBuilder(
              valueListenable: countAddToCartItem,
              builder: (context, _, child) {
                return TextButton.icon(
                  onPressed: () {
                    if (countAddToCartItem.value == 0) {
                      items.value.clear();
                    }
                    Navigator.of(context)
                        .push(pageRouteAnimate(const CheckOutScreen()))
                        .then((value) {
                      if (value != null && value != "" && value != ".") {
                        quantities.value = value;

                        print(value.toString());
                        print("sads");

                        setState(() {});
                      }
                    });
                  },
                  icon: Stack(
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: ScaleTransition(
                            scale: _animation,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.redAccent,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  label: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 30,
                      width: 30,
                      padding: const EdgeInsets.only(top: 8),
                      color: Colors.grey.shade100,
                      child: Text(
                        countAddToCartItem.value.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
      drawer: buildDrawer(context),
      body: bodyContent(size),
    );
  }

  Column bodyContent(Size size) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: searchTextField(),
        ),
        Expanded(
          child: RefreshIndicator(
            color: Colors.black,
            onRefresh: () async {
              await _fetchDataProduct();
              addLimitTenItem.value = 10;
              countAddToCartItem.value = 0;
              items.value.clear();
            },
            child: data.value!.isEmpty && searchController.text.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : data.value!.isEmpty && searchController.text.isNotEmpty
                    ? const Center(child: Text('No Search Found...'))
                    : GridView.count(
                        //crossAxisSpacing: 10,
                        controller: _controller,
                        crossAxisCount: 2,
                        childAspectRatio: 8.0 / 9.8,
                        children: List.generate(data.value!.length, (index) {
                          data.value!
                              .sort((a, b) => a.title.toString().compareTo(b.title.toString()));

                          if (countAddToCartItem.value <= 0) {
                            countAddToCartItem.value = 0;
                            items.value.clear();
                            quantities.value = List.generate(qty.value, (_) => 0);

                            print(quantities.value.toString());
                          }

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      height: size.height * .20,
                                      width: size.width,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 10.0,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Hero(
                                        tag: data.value![index].id.toString(),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: data.value![index].thumbnail.toString(),
                                          progressIndicatorBuilder:
                                              (context, url, downloadProgress) =>
                                                  CircularProgressIndicator(
                                                      value: downloadProgress.progress),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(AssetStorageImage.eCommerceLogo),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * .02,
                                  ),
                                  SubstringHighlight(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold, color: Colors.blue),
                                    text: data.value![index].title.toString(),
                                    term: highLightSearchtTerm,
                                  ),
                                  Text(
                                    data.value![index].price.toString() ?? "",
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: countBuyItem,
                                      builder: (context, _, child) {
                                        return Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            OutlinedButton(
                                              onPressed: () {
                                                if (quantities.value![index] != 0) {
                                                  countBuyItem.value = quantities.value![index]--;
                                                  //data.value![index].qty = countBuyItem.value;

                                                  countAddToCartItem.value =
                                                      countAddToCartItem.value - 1;

                                                  for (int i = 0; i < items.value.length; i++) {
                                                    if (items.value[i]['id'] ==
                                                        data.value![index].id) {
                                                      print("ada");
                                                      items.value[i]['quantity'] =
                                                          countBuyItem.value - 1;
                                                      break;
                                                    }
                                                  }

                                                  // items.value[index]['quantity'] =
                                                  //     countBuyItem.value - 1;
                                                } else {
                                                  // countAddItemToCart();
                                                }
                                              },
                                              child: Text("-"),
                                            ),
                                            ValueListenableBuilder(
                                                valueListenable: quantities,
                                                builder: (context, _, child) {
                                                  return Text(
                                                      quantities.value?[index].toString() ?? "");
                                                }),
                                            OutlinedButton(
                                              onPressed: () {
                                                countBuyItem.value = quantities.value![index]++;
                                                // productItems.value![index].qty = quantities.value![index]++;
                                                //data.value![index].qty = countBuyItem.value;
                                                //countAddItemToCart();

                                                countAddToCartItem.value =
                                                    countAddToCartItem.value + 1;

                                                bool keyExists = items.value
                                                    .any((map) => map.containsKey('quantity'));

                                                if (keyExists) {
                                                  for (int i = 0; i < items.value.length; i++) {
                                                    if (items.value[i]['id'] ==
                                                        data.value![index].id) {
                                                      print("ada");
                                                      items.value[i]['quantity'] =
                                                          countBuyItem.value + 1;
                                                      break;
                                                    }
                                                  }
                                                }
                                                // print("okey");
                                                // print(items.value.toString());
                                              },
                                              child: Text("+"),
                                            )
                                          ],
                                        );
                                      }),
                                  ValueListenableBuilder(
                                      valueListenable: countBuyItem,
                                      builder: (BuildContext context, _, Widget? child) {
                                        return addToCartButton(index);
                                      }),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
          ),
        ),
        ValueListenableBuilder(
            valueListenable: isLoading,
            builder: (context, _, child) {
              return isLoading.value
                  ? const Center(
                      child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(),
                    ))
                  : const SizedBox.shrink();
            }),
      ],
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.blue],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: circleAvatar(userLoggedIn?.imageUrl.toString() ?? ""),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    userLoggedIn?.firstName.toString() ?? "",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.black),
            title: const Text('Products'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.notification_add_sharp,
              color: Colors.green,
            ),
            title: const Text('Send Notification'),
            onTap: () async {
              sendPushMessage(
                  userLoggedIn!.token.toString(),
                  "From : ${userLoggedIn!.firstName.toString()}",
                  "Hello ${userLoggedIn!.firstName.toString()}");
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_outlined,
              color: Colors.red,
            ),
            title: const Text('Logout'),
            onTap: () async {
              items.value.clear();
              countAddToCartItem.value = 0;
              await FirebaseAuth.instance.signOut();
              await _googleSignIn.signOut();
              goToSingInScreen();
            },
          ),
        ],
      ),
    );
  }

  void qtyCount(int index) {
    bool isAdded = items.value.any((item) => item['id'] == data.value![index].id.toString());

    if (!isAdded) {
      items.value.add({
        'id': data.value![index].id,
        'count': index,
        'title': data.value?[index].title.toString() ?? "",
        'description': data.value?[index].description.toString() ?? "",
        'price': data.value?[index].price,
        'thumbnail': data.value?[index].thumbnail.toString() ?? "",
        'quantity': quantities.value?[index] ?? 0,
      });
      _animateController.forward().then((_) => _animateController.reverse());
    } else {
      displayErrorMessage('You already Added this item.');
      print("You already Added this item");
    }
  }

  OutlinedButton addToCartButton(int index) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
        backgroundColor: quantities.value![index] == 0 ? Colors.grey.shade100 : AppColors.logoColor,
      ),

      onPressed: quantities.value![index] == 0
          ? null
          : () {
              qtyCount(index);
              // bool isAddeds = productItems.value!
              //     .any((item) => item.id.toString() == data.value![index].id.toString());
              // if (!isAddeds) {
              //   productItems.value![index].id = data.value![index].id;
              //   productItems.value![index].title = data.value![index].title.toString();
              //   productItems.value![index].description = data.value![index].description.toString();
              //   productItems.value![index].price = data.value![index].price;
              //   productItems.value![index].discountPercentage =
              //       data.value![index].discountPercentage;
              //   productItems.value![index].stock = int.parse(data.value![index].rating.toString());
              //   productItems.value![index].brand = data.value![index].brand;
              //   productItems.value![index].category = data.value![index].category;
              //   productItems.value![index].thumbnail = data.value![index].thumbnail;
              //   productItems.value![index].qty = data.value![index].qty;
              //
              //   _animateController.forward().then((_) => _animateController.reverse());
              // }

              // items.value.add({
              //   'id': _data.value![index].id.toString() ?? "",
              //   'title': _data.value![index].title.toString() ?? "",
              //   'description': _data.value![index].description.toString() ?? "",
              //   'price': _data.value![index].price,
              //   'thumbnail': _data.value![index].thumbnail.toString() ?? "",
              //   'quantity': quantities.value?[index] ?? 0,
              // });

              // productItems.value![index].id = data.value![index].id;
              // productItems.value![index].title = data.value![index].title;
              // productItems.value![index].description = data.value![index].description;
              // productItems.value![index].price = data.value![index].price;
              // productItems.value![index].id = data.value![index].id;
              //
              // print(productItems.value.toString());
              // print(productItems.value!.length.toString());
              // print("KK");

              countAddItemToCart();
            },
      icon: Icon(
        Icons.add_shopping_cart,
        color: quantities.value![index] == 0 ? Colors.grey.shade300 : Colors.black,
        size: 24.0,
      ),
      label: Text(
        'Add To Cart',
        style:
            TextStyle(color: quantities.value![index] == 0 ? Colors.grey.shade300 : Colors.white),
      ), // <-- Text
    );
  }

  TextField searchTextField() {
    return TextField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: searchController,
      decoration: InputDecoration(
        focusedBorder:
            const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black)),
        suffixIcon: const Icon(
          Icons.search,
          color: Colors.black,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        hintText: 'Search...',
        fillColor: Colors.white,
        filled: true,
      ),
      onChanged: (value) {
        setState(() {
          highLightSearchtTerm = value.toUpperCase();
          _searchFilter(value.toUpperCase());
        });
      },
    );
  }

  void displayErrorMessage(String message) {
    ToastMessage.showMessage(message, context,
        offSetBy: 0,
        position: const StyledToastPosition(align: Alignment.topCenter, offset: 200.0),
        isShapedBorder: false);
  }
}

import 'dart:convert';
import 'package:adopt_a_pet/pages/Factorial/factorial-screen.dart';
import 'package:adopt_a_pet/widgets/cache-network-image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:adopt_a_pet/pages/SignIn-SignUp/signin-screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:substring_highlight/substring_highlight.dart';

import '../../All-Constants/color_constants.dart';
import '../../All-Constants/global_variable.dart';
import '../../model/product-model.dart';
import '../../router/Navigate-Route.dart';
import '../../utilities/AssetStorageImage.dart';
import '../../widgets/RichText-HightTermText.dart';

part 'homescreen-controller-extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<ProductModel>? _data = [];
  List<ProductModel>? searchData = [];

  final ScrollController _controller = ScrollController();
  var isLoading = ValueNotifier<bool>(false);
  var addLimitTenItem = ValueNotifier<int>(10);
  var countBuyItem = ValueNotifier<int>(0);
  var countAddToCartItem = ValueNotifier<int>(0);

  int? qty = 0;

  TextEditingController searchController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String highLightSearchtTerm = "";

  List<int>? quantities;
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    _fetchDataProduct();
    scrollLimit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    quantities = List.filled(qty!, 0);

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
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add_shopping_cart_sharp,
                    color: Colors.red,
                  ),
                  label: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 30,
                      width: 30,
                      padding: EdgeInsets.only(top: 8),
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
      drawer: Drawer(
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
              title: const Text('Data Management'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen(),
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
                Icons.medical_information_outlined,
                color: Colors.blue,
              ),
              title: const Text('Factorial'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const FactorialScreen(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout_outlined,
                color: Colors.red,
              ),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                await _googleSignIn.signOut();
                goToSingInScreen();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: size.height * .02),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: searchTextField(),
          ),
          SizedBox(height: size.height * .02),
          Expanded(
            child: RefreshIndicator(
              color: Colors.black,
              onRefresh: () async {
                await _fetchDataProduct();
                addLimitTenItem.value = 10;
              },
              child: ValueListenableBuilder(
                valueListenable: addLimitTenItem,
                builder: (BuildContext context, _, Widget? child) {
                  if (_data!.isEmpty && searchController.text.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (_data!.isEmpty && searchController.text.isNotEmpty) {
                    return const Center(child: Text('No Search Found...'));
                  }
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.count(
                      controller: _controller,
                      crossAxisCount: 2,
                      childAspectRatio: 8.0 / 9.8,
                      children: List.generate(_data!.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: Card(
                            child: Container(
                              height: size.height,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                gradient: LinearGradient(
                                  colors: [Colors.white, Colors.grey.shade200],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    height: size.height * .10,
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
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: _data?[index].thumbnail.toString() ?? "",
                                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(AssetStorageImage.appLogo),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          child: SubstringHighlight(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold, color: Colors.blue),
                                            text: _data?[index].title.toString() ??
                                                "", // search result string from database or something
                                            term: highLightSearchtTerm, // user typed "et"
                                          ),
                                          // child: Text(
                                          //   _data?[index].title.toString() ?? "",
                                          //   style: TextStyle(fontWeight: FontWeight.bold),
                                          // ),
                                        ),
                                        Text(
                                          _data?[index].price.toString() ?? "",
                                        ),
                                      ],
                                    ),
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
                                                if (quantities![index] != 0) {
                                                  countBuyItem.value = quantities![index]--;
                                                  countAddItemToCart();
                                                }
                                              },
                                              child: Text("-"),
                                            ),
                                            Text("${quantities![index]}"),
                                            OutlinedButton(
                                              onPressed: () {
                                                countBuyItem.value = quantities![index]++;

                                                countAddItemToCart();
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
                              ), //   items.add({
                              //     'id': _data?[index].id.toString() ?? "",
                              //     'title': _data?[index].title.toString() ?? "",
                              //     'description': _data?[index].description.toString() ?? "",
                              //     'price': _data?[index].price.toString() ?? "",
                              //     'quantity': quantities?[index] ?? 0,
                              //   });
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
          ),
          OutlinedButton(onPressed: () {}, child: Text("Check Out")),
          ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (BuildContext context, _, Widget? child) {
                return isLoading.value
                    ? const Center(
                        child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(),
                      ))
                    : const SizedBox.shrink();
              }),
        ],
      ),
    );
  }

  OutlinedButton addToCartButton(int index) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
        backgroundColor: quantities![index] == 0 ? Colors.grey.shade100 : AppColors.logoColor,
      ),

      onPressed: quantities![index] == 0
          ? null
          : () {
              items.where((item) => item['id'] == _data?[index].id.toString()).toList();
              // if (items.isEmpty) {
              //   items.add({
              //     'id': _data?[index].id.toString() ?? "",
              //     'title': _data?[index].title.toString() ?? "",
              //     'description': _data?[index].description.toString() ?? "",
              //     'price': _data?[index].price.toString() ?? "",
              //     'quantity': quantities?[index] ?? 0,
              //   });
              // } else {
              //   print("Ypou already Added this item");
              // }

              items.add({
                'id': _data?[index].id.toString() ?? "",
                'title': _data?[index].title.toString() ?? "",
                'description': _data?[index].description.toString() ?? "",
                'price': _data?[index].price.toString() ?? "",
                'quantity': quantities?[index] ?? 0,
              });
              print(items.length.toString());
              print("ITEMS");
            },
      icon: Icon(
        Icons.add_shopping_cart,
        color: Colors.grey.shade600,
        size: 24.0,
      ),
      label: const Text(
        'Add To Cart',
        style: TextStyle(color: Colors.black),
      ), // <-- Text
    );
  }

  Row addMinusButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        OutlinedButton(
          onPressed: () {},
          child: Text("-"),
        ),
        Text("1"),
        OutlinedButton(
          onPressed: () {},
          child: Text("+"),
        )
      ],
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
}

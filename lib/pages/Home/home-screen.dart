import 'dart:convert';
import 'package:adopt_a_pet/pages/Home/check-out-screen.dart';
import 'package:adopt_a_pet/pages/Home/sample.dart';
import 'package:adopt_a_pet/pages/Server/APi-Response.dart';
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
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';
import '../../All-Constants/color_constants.dart';
import '../../All-Constants/global_variable.dart';
import '../../model/product-model.dart';
import '../../model/student-model.dart';
import '../../router/Navigate-Route.dart';
import '../../utilities/AssetStorageImage.dart';
import '../../widgets/Toast-Message.dart';
import '../Server/NetworkDataSource.dart';
import '../Server/Repository.dart';

part 'home-controller-extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  //List<ProductModel>? _data = [];
  List<ProductModel>? searchData = [];
  var dataProducts = ValueNotifier<List<ProductModel>?>([]);

  bool isLike = false;

  final ScrollController _controller = ScrollController();
  var isLoading = ValueNotifier<bool>(false);
  var addLimitTenItem = ValueNotifier<int>(10);

  TextEditingController searchController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String highLightSearchtTerm = "";
  String label = "Already Added";

  int x = 0;
  var list;

  late AnimationController _animateController;
  late Animation<double> _animation;

  var qnty;

  void fetchings() {
    dataProducts.value = dataProduct.value;

    print(dataProducts.value!.length.toString());
    print("sz");
  }

  @override
  void initState() {
    _animateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animateController);
    fetch();
    //_fetchDataProduct();
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

    print("scafold");

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
              valueListenable: countBuyItem,
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
                        countBuyItem.value.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
                //return buildLikeButton();
              }),
        ],
      ),
      drawer: buildDrawer(context),
      body: bodyContent(size),
    );
  }

  // LikeButton buildLikeButton() {
  //   return LikeButton(
  //     isLiked: countBuyItem.value[1],
  //     // onTap: (val) async {
  //     //   return countBuyItem.value[1];
  //     // },
  //     size: 20,
  //     circleColor: CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
  //     bubblesColor: BubblesColor(
  //       dotPrimaryColor: Color(0xff33b5e5),
  //       dotSecondaryColor: Color(0xff0099cc),
  //     ),
  //     likeBuilder: (bool isLiked) {
  //       return Icon(
  //         Icons.home,
  //         color: countBuyItem.value[1] ? Colors.deepPurpleAccent : Colors.grey,
  //         size: 20,
  //       );
  //     },
  //     likeCount: countBuyItem.value[0],
  //     countBuilder: (int? count, bool isLiked, String text) {
  //       var color = countBuyItem.value[1] ? Colors.deepPurpleAccent : Colors.grey;
  //       Widget result;
  //       if (count == 0) {
  //         result = Text(
  //           "love",
  //           style: TextStyle(color: color),
  //         );
  //       } else
  //         result = Text(
  //           text,
  //           style: TextStyle(color: color),
  //         );
  //       return result;
  //     },
  //   );
  // }

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
              //await _fetchDataProduct();
              await fetch();
              countBuyItem.value = 0;
              addLimitTenItem.value = 10;
              countAddToCartItem.value = 0;
              items.value.clear();
            },
            child: dataProducts.value!.isEmpty && searchController.text.isEmpty
                ? const Center(child: Center(child: CircularProgressIndicator()))
                : GridView.count(
                    //crossAxisSpacing: 10,
                    controller: _controller,
                    crossAxisCount: 2,
                    childAspectRatio: 8.0 / 12.8,
                    children: List.generate(dataProducts.value!.length, (index) {
                      dataProducts.value!
                          .sort((a, b) => a.title.toString().compareTo(b.title.toString()));

                      if (countAddToCartItem.value <= 0) {
                        countAddToCartItem.value = 0;
                        items.value.clear();

                        quantities.value = List.generate(qty.value, (_) => 0);

                        print(quantities.value.toString());
                      }

                      qnty = Provider.of<ProviderController>(context, listen: false).getQuantities;

                      list = Provider.of<ProviderController>(context, listen: false).getListItems;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
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
                                tag: dataProducts.value![index].id.toString(),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: dataProducts.value![index].thumbnail.toString(),
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      CircularProgressIndicator(value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(AssetStorageImage.eCommerceLogo),
                                ),
                              ),
                            ),
                            Text(
                              dataProducts.value![index].title.toString(),
                            ),
                            Text(
                              dataProducts.value![index].price.toString(),
                            ),
                            SizedBox(
                              height: size.height * .02,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    if (dataProducts.value![index].qty != 0) {
                                      dataProducts.value![index].qty -= 1;
                                      countBuyItem.value -= 1;
                                    }
                                  },
                                  child: Text("-"),
                                ),
                                ValueListenableBuilder(
                                    valueListenable: countBuyItem,
                                    builder: (context, val, child) {
                                      return Text(dataProducts.value![index].qty.toString());
                                    }),
                                OutlinedButton(
                                  onPressed: () {
                                    dataProducts.value![index].qty += 1;

                                    countBuyItem.value += 1;
                                  },
                                  child: Text("+"),
                                )
                              ],
                            ),
                          ],
                        ),

                        // Card(
                        //   child: Column(
                        //     children: [
                        //       Expanded(
                        //         child: Container(
                        //           padding: const EdgeInsets.only(bottom: 5),
                        //           height: size.height * .20,
                        //           width: size.width,
                        //           decoration: const BoxDecoration(
                        //             color: Colors.white,
                        //             boxShadow: [
                        //               BoxShadow(
                        //                 color: Colors.black12,
                        //                 blurRadius: 10.0,
                        //                 offset: Offset(0, 10),
                        //               ),
                        //             ],
                        //           ),
                        //           child: Hero(
                        //             tag: dataProducts.value![index].id.toString(),
                        //             child: CachedNetworkImage(
                        //               fit: BoxFit.cover,
                        //               imageUrl: dataProducts.value![index].thumbnail.toString(),
                        //               progressIndicatorBuilder: (context, url, downloadProgress) =>
                        //                   CircularProgressIndicator(
                        //                       value: downloadProgress.progress),
                        //               errorWidget: (context, url, error) =>
                        //                   Image.asset(AssetStorageImage.eCommerceLogo),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         height: size.height * .02,
                        //       ),
                        //       SubstringHighlight(
                        //         textStyle: const TextStyle(
                        //             fontWeight: FontWeight.bold, color: Colors.blue),
                        //         text: dataProducts.value![index].title.toString(),
                        //         term: highLightSearchtTerm,
                        //       ),
                        //       Text(
                        //         dataProducts.value![index].price.toString() ?? "",
                        //       ),
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //         children: [
                        //           OutlinedButton(
                        //             onPressed: () {
                        //               if (dataProducts.value![index].qty != 0) {
                        //                 dataProducts.value![index].qty -= 1;
                        //                 countBuyItem.value -= 1;
                        //               }
                        //               // if (qnty[index] != 0) {
                        //               //   Provider.of<ProviderController>(context, listen: false)
                        //               //       .addItemAtIndex(index, qnty[index] - 1);
                        //               //   countAddToCartItem.value -= 1;
                        //               //
                        //               //   for (int i = 0; i < list.length; i++) {
                        //               //     if (list[i]['id'] == data.value![index].id) {
                        //               //       list[i]['quantity'] = list[i]['quantity'] - 1;
                        //               //       break;
                        //               //     }
                        //               //   }
                        //               // } else {}
                        //             },
                        //             child: Text("-"),
                        //           ),
                        //
                        //           ValueListenableBuilder(
                        //               valueListenable: countBuyItem,
                        //               builder: (context, val, child) {
                        //                 return Text(dataProducts.value![index].qty.toString());
                        //               }),
                        //
                        //           // Text(Provider.of<ProviderController>(context, listen: true)
                        //           //     .getQuantities[index]
                        //           //     .toString()),
                        //           OutlinedButton(
                        //             onPressed: () {
                        //               dataProducts.value![index].qty += 1;
                        //
                        //               countBuyItem.value += 1;
                        //
                        //               isLike = true;
                        //
                        //               print(dataProducts.value![index].qty.toString());
                        //               //setState(() {});
                        //
                        //               // Provider.of<ProviderController>(context, listen: false)
                        //               //     .addItemAtIndex(index, qnty[index] + 1);
                        //               //
                        //               // bool keyExists = list.any(
                        //               //     (map) => map.containsKey('quantity') ? true : false);
                        //               // if (keyExists) {
                        //               //   for (int i = 0; i < list.length; i++) {
                        //               //     if (list[i]['id'] == data.value![index].id) {
                        //               //       list[i]['quantity'] = list[i]['quantity'] + 1;
                        //               //       break;
                        //               //     }
                        //               //   }
                        //               // }
                        //             },
                        //             child: Text("+"),
                        //           )
                        //         ],
                        //       ),
                        //       // ValueListenableBuilder(
                        //       //     valueListenable: countBuyItem,
                        //       //     builder: (BuildContext context, _, Widget? child) {
                        //       //       return addToCartButton(index);
                        //       //     }),
                        //     ],
                        //   ),
                        // ),
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
                builder: (BuildContext context) => Sample(
                  title: "List",
                ),
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
    bool isAdded =
        items.value.any((item) => item['id'] == dataProducts.value![index].id.toString());

    if (!isAdded) {
      List<Map<String, dynamic>> itemz = [];

      List<ProductModel> product = [];

      itemz.add({
        'id': dataProducts.value![index].id,
        'count': index,
        'title': dataProducts.value?[index].title.toString() ?? "",
        'description': dataProducts.value?[index].description.toString() ?? "",
        'price': dataProducts.value?[index].price,
        'thumbnail': dataProducts.value?[index].thumbnail.toString() ?? "",
        'quantity': qnty[index] ?? 0,
      });
      Provider.of<ProviderController>(context, listen: false).setListItems([
        {
          'id': dataProducts.value![index].id,
          'count': index,
          'title': dataProducts.value?[index].title.toString() ?? "",
          'description': dataProducts.value?[index].description.toString() ?? "",
          'price': dataProducts.value?[index].price,
          'thumbnail': dataProducts.value?[index].thumbnail.toString() ?? "",
          'quantity': qnty[index] ?? 0,
        }
      ]);
      countAddToCartItem.value = countAddToCartItem.value +
          int.parse(Provider.of<ProviderController>(context, listen: false)
              .getQuantities[index]
              .toString());

      print(countAddToCartItem.value.toString());

      _animateController.forward().then((_) => _animateController.reverse());
    } else {
      displayErrorMessage('You already Added this item.');
      print("You already Added this item");
    }

    var list = Provider.of<ProviderController>(context, listen: false).getListItems;
  }

  OutlinedButton addToCartButton(int index) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
        backgroundColor: qnty[index] == 0 ? Colors.grey.shade100 : AppColors.logoColor,
      ),

      onPressed: qnty[index] == 0
          ? null
          : () {
              qtyCount(index);
            },
      icon: Icon(
        Icons.add_shopping_cart,
        color: qnty[index] == 0 ? Colors.grey.shade300 : Colors.black,
        size: 24.0,
      ),
      label: Text(
        qnty[index] == 0 ? "Add To Cart" : label,
        style: TextStyle(color: qnty[index] == 0 ? Colors.grey.shade300 : Colors.white),
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

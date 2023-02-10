import 'dart:convert';
import 'package:adopt_a_pet/pages/Home/check-out-screen.dart';
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
import '../../model/student-model.dart';
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
  String label = "Already Added";

  int x = 0;
  var list;

  late AnimationController _animateController;
  late Animation<double> _animation;

  var qnty;

  @override
  void initState() {
    Student student = Student(name: 'John Doe', course: 'Computer Science');
    print(student.name); // Output: John Doe
    print(student.course); // Output: Computer Science
    print('student info');

    Student student2 = Student();
    print(student2.name ?? "ada"); // Output: Unknown
    print(student2.course ?? "adad"); // Ou
    print('student info');

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

                          qnty =
                              Provider.of<ProviderController>(context, listen: false).getQuantities;

                          list =
                              Provider.of<ProviderController>(context, listen: false).getListItems;

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
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          if (qnty[index] != 0) {
                                            Provider.of<ProviderController>(context, listen: false)
                                                .addItemAtIndex(index, qnty[index] - 1);
                                            countAddToCartItem.value -= 1;

                                            for (int i = 0; i < list.length; i++) {
                                              if (list[i]['id'] == data.value![index].id) {
                                                list[i]['quantity'] = list[i]['quantity'] - 1;
                                                break;
                                              }
                                            }
                                          } else {}
                                        },
                                        child: Text("-"),
                                      ),
                                      Text(Provider.of<ProviderController>(context, listen: true)
                                          .getQuantities[index]
                                          .toString()),
                                      OutlinedButton(
                                        onPressed: () {
                                          Provider.of<ProviderController>(context, listen: false)
                                              .addItemAtIndex(index, qnty[index] + 1);

                                          bool keyExists = list.any(
                                              (map) => map.containsKey('quantity') ? true : false);
                                          if (keyExists) {
                                            for (int i = 0; i < list.length; i++) {
                                              if (list[i]['id'] == data.value![index].id) {
                                                list[i]['quantity'] = list[i]['quantity'] + 1;
                                                break;
                                              }
                                            }
                                          }
                                        },
                                        child: Text("+"),
                                      )
                                    ],
                                  ),
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
      List<Map<String, dynamic>> itemz = [];

      List<ProductModel> product = [];

      itemz.add({
        'id': data.value![index].id,
        'count': index,
        'title': data.value?[index].title.toString() ?? "",
        'description': data.value?[index].description.toString() ?? "",
        'price': data.value?[index].price,
        'thumbnail': data.value?[index].thumbnail.toString() ?? "",
        'quantity': qnty[index] ?? 0,
      });
      Provider.of<ProviderController>(context, listen: false).setListItems([
        {
          'id': data.value![index].id,
          'count': index,
          'title': data.value?[index].title.toString() ?? "",
          'description': data.value?[index].description.toString() ?? "",
          'price': data.value?[index].price,
          'thumbnail': data.value?[index].thumbnail.toString() ?? "",
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

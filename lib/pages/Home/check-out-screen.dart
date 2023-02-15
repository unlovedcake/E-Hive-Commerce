import 'package:adopt_a_pet/pages/Home/payment-method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../All-Constants/color_constants.dart';
import '../../All-Constants/global_variable.dart';
import '../../model/product-model.dart';
import '../../provider-controller/Provider-Controller.dart';
import '../../router/Navigate-Route.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  var totalPayment = ValueNotifier<double>(0.0);

  var cartItem = ValueNotifier<List<ProductModel>?>([]);

  void _totalPayment() {
    cartItem.value = dataProduct.value?.where((productCode) => productCode.qty != 0).toList();

    for (int i = 0; i < cartItem.value!.length; i++) {
      totalPayment.value += cartItem.value![i].price! * cartItem.value![i].qty;
    }
  }

  @override
  void initState() {
    _totalPayment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (items.value.isEmpty) {
      countAddToCartItem.value = 0;
    }

    var getItems = Provider.of<ProviderController>(context, listen: false).getListItems;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop(quantities.value);
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'Check Out',
          style: TextStyle(
            color: AppColors.logoColor,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: cartItem.value!.isEmpty
          ? const Center(child: Text('No Cart Added yet..'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItem.value!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            Image.network(
                              cartItem.value![index].thumbnail.toString(),
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem.value![index].title.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: size.height * .04),
                                  priceAndQuantityValue(
                                      "Price : ", cartItem.value![index].price.toString()),
                                  ValueListenableBuilder(
                                      valueListenable: countBuyItem,
                                      builder: (context, val, child) {
                                        return priceAndQuantityValue(
                                            "Qty : ", cartItem.value![index].qty.toString());
                                      }),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          if (cartItem.value![index].qty != 0) {
                                            cartItem.value![index].qty -= 1;
                                            countBuyItem.value -= 1;

                                            totalPayment.value -= cartItem.value![index].price!;
                                            //_totalPayment();
                                          }

                                          print(cartItem.value![index].id.toString());

                                          if (cartItem.value![index].qty == 0) {
                                            setState(() {
                                              cartItem.value!.removeWhere(
                                                  (item) => item.id == cartItem.value![index].id);
                                              print("delete");
                                            });
                                          }
                                        },
                                        child: Text("-"),
                                      ),

                                      // Text(Provider.of<ProviderController>(context, listen: true)
                                      //     .getQuantities[index]
                                      //     .toString()),
                                      OutlinedButton(
                                        onPressed: () {
                                          cartItem.value![index].qty += 1;

                                          countBuyItem.value += 1;

                                          cartItem.value = dataProduct.value
                                              ?.where((productCode) => productCode.qty != 0)
                                              .toList();

                                          totalPayment.value += cartItem.value![index].price!;

                                          //_totalPayment();
                                        },
                                        child: Text("+"),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.height * .04,
                                  ),
                                  OutlinedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.black,
                                        minimumSize: const Size.fromHeight(50),
                                      ),
                                      onPressed: () {
                                        //totalPayment.value -= getItems[index]['price'];

                                        setState(() {
                                          countBuyItem.value -= cartItem.value![index].qty;
                                          cartItem.value![index].qty = 0;
                                          _totalPayment();
                                        });
                                      },
                                      child: const Text("Cancel"))
                                ],
                              ),
                            ),
                          ],
                        ),
                      );

                      // return Card(
                      //   child: ListTile(
                      //     title: Text(items[index]['title'].toString()),
                      //   ),
                      // );
                    },
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: totalPayment,
                    builder: (context, _, child) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Total Payment : ",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.bold),
                                ),
                                FittedBox(
                                  child: Text(
                                    totalPayment.value.toString(),
                                    style:
                                        const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: size.width,
                              child: OutlinedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: AppColors.logoColor,
                                    minimumSize: const Size.fromHeight(50),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(pageRouteAnimate(const PaymentMethodScreen()));
                                  },
                                  child: const Text("Pay")),
                            )
                          ],
                        ),
                      );
                    }),
              ],
            ),
    );
  }

  RichText priceAndQuantityValue(String label, String qty) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(color: Colors.black, fontSize: 18),
        children: <TextSpan>[
          TextSpan(text: qty, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
}

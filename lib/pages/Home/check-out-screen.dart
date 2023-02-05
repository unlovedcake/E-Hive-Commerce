import 'package:adopt_a_pet/pages/Home/payment-method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../All-Constants/color_constants.dart';
import '../../All-Constants/global_variable.dart';
import '../../router/Navigate-Route.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  var totalPayment = ValueNotifier<double>(0.0);

  @override
  void initState() {
    for (int i = 0; i < items.value.length; i++) {
      totalPayment.value += items.value[i]['price'] * items.value[i]['quantity'];
    }

    super.initState();
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
          'Check Out',
          style: TextStyle(
            color: AppColors.logoColor,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: items.value.isEmpty
          ? const Center(child: Text('No Cart Added yet..'))
          // : ListView.separated(
          //     separatorBuilder: (context, index) => const Divider(),
          //     itemCount: items.value.length,
          //     itemBuilder: (context, index) {
          //       return Slidable(
          //         // Specify a key if the Slidable is dismissible.
          //         key: ValueKey(index),
          //
          //         startActionPane: ActionPane(
          //           motion: const ScrollMotion(),
          //           // dismissible: DismissiblePane(onDismissed: () {
          //           //
          //           // }),
          //           children: [
          //             // SlidableAction(
          //             //   onPressed: (val) {},
          //             //   backgroundColor: const Color(0xFFFE4A49),
          //             //   foregroundColor: Colors.white,
          //             //   icon: Icons.delete,
          //             //   label: 'Delete',
          //             // ),
          //             SlidableAction(
          //               onPressed: (val) {},
          //               backgroundColor: Color(0xFF21B7CA),
          //               foregroundColor: Colors.white,
          //               icon: Icons.share,
          //               label: 'Pet Profile',
          //             ),
          //           ],
          //         ),
          //
          //         // The end action pane is the one at the right or the bottom side.
          //         endActionPane: ActionPane(
          //           motion: const ScrollMotion(),
          //           children: [
          //             SlidableAction(
          //               // An action can be bigger than the others.
          //               flex: 2,
          //               onPressed: (val) {
          //                 print("REMOVE");
          //
          //                 setState(() {
          //                   items.value.removeAt(index);
          //                   totalPayment.value -= items.value[index]['price'];
          //
          //                   countAddToCartItem.value -=
          //                       int.parse(items.value[index]['quantity'].toString());
          //                 });
          //               },
          //               backgroundColor: const Color(0xFF7BC043),
          //               foregroundColor: Colors.white,
          //               icon: Icons.archive,
          //               label: 'Hide',
          //             ),
          //           ],
          //         ),
          //
          //         // The child of the Slidable is what the user sees when the
          //         // component is not dragged.
          //         child: Card(
          //           child: ListTile(
          //               onTap: () {},
          //               subtitle: Text(items.value[index]['price'].toString()),
          //               leading: Container(
          //                 decoration: const BoxDecoration(
          //                   color: Colors.white,
          //                   boxShadow: [
          //                     BoxShadow(
          //                       color: Colors.black12,
          //                       blurRadius: 10.0,
          //                       offset: Offset(0, 10),
          //                     ),
          //                   ],
          //                 ),
          //                 child: CachedNetworkImage(
          //                   height: size.height * .46,
          //                   imageUrl: items.value[index]['thumbnail'].toString(),
          //                   progressIndicatorBuilder: (context, url, downloadProgress) =>
          //                       CircularProgressIndicator(value: downloadProgress.progress),
          //                   errorWidget: (context, url, error) =>
          //                       Image.asset(AssetStorageImage.appLogo),
          //                 ),
          //               ),
          //               title: Text(items.value[index]['title'].toString())),
          //         ),
          //       );
          //     },
          //   )
          : ValueListenableBuilder(
              valueListenable: items,
              builder: (context, _, child) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.value.length,
                        itemBuilder: (context, index) {
                          print(index);
                          print("index");
                          print(items.value.length);

                          return Card(
                            child: Column(
                              children: [
                                Image.network(
                                  items.value[index]['thumbnail'].toString(),
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        items.value[index]['title'].toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: size.height * .04),
                                      priceAndQuantityValue(
                                          "Price : ", items.value[index]['price'].toString()),
                                      priceAndQuantityValue(
                                          "Qty : ", items.value[index]['quantity'].toString()),
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
                                            totalPayment.value -= items.value[index]['price'];

                                            if (countAddToCartItem.value > 0) {
                                              countAddToCartItem.value -= int.parse(
                                                  items.value[index]['quantity'].toString());
                                              //quantities.value?[index] = 0;
                                              //quantities.value = List.generate(qty.value, (_) => 0);
                                            } else if (index <= 0) {
                                              countAddToCartItem.value = 0;
                                              quantities.value = List.generate(qty.value, (_) => 0);
                                            }

                                            setState(() {
                                              items.value.removeAt(index);
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
                            child: Row(
                              children: [
                                Text(
                                  "Total Payment : ",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  totalPayment.value.toString(),
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: size.width * .28,
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
                );
              }),
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

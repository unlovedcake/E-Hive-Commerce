import 'dart:convert';
import 'package:adopt_a_pet/pages/Home/home-screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../All-Constants/color_constants.dart';
import '../../All-Constants/global_variable.dart';
import '../../router/Navigate-Route.dart';
import '../../utilities/AssetStorageImage.dart';
import '../../widgets/Loading-Indicator.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          title: const Text(
            'Payment Method',
            style: TextStyle(
              color: AppColors.logoColor,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Center(
            child: Container(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.all(12),
              backgroundColor: Colors.white,
            ),
            onPressed: () async {
              startShowLoadingView();
              sendPushMessage(userLoggedIn!.token.toString(),
                  "From : ${userLoggedIn!.firstName.toString()}", "You have successfuly paid.");

              await Future.delayed(const Duration(seconds: 3), () {
                Navigator.pop(context);
                items.value.clear();
                countAddToCartItem.value = 0;
                Navigator.of(context).pushReplacement(pageRouteAnimate(const HomeScreen()));
              });
            },
            icon: Image.asset(
              AssetStorageImage.gCashLogo,
              width: 30,
              height: 30,
            ),
            label: const Text("Pay With Gcash"),
          ),
        )));
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

  void startShowLoadingView() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return LoadingIndicator();
      },
    );
  }
}

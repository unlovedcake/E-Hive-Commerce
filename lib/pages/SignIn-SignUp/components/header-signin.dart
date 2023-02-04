import 'package:flutter/material.dart';

import '../../../All-Constants/size_constants.dart';

class HeaderSignIn extends StatelessWidget {
  final String? label;
  const HeaderSignIn(this.label, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.appPadding,
        vertical: Sizes.appPadding / 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.04),
          Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'Welcome\n',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: label,
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  ),
                ),
              ),
              Image.asset(
                'asset/images/app-logo.png',
                width: 100,
                height: 100,
              )
            ],
          ),
          // const Text(
          //   'Welcome',
          //   style: TextStyle(
          //     fontSize: 24,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          // const Text(
          //   'SIGN IN',
          //   style: TextStyle(
          //     fontSize: 36,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ],
      ),
    );
  }
}

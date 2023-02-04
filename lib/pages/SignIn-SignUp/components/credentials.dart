import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../All-Constants/size_constants.dart';
import 'animated-signin-textfield.dart';

class Credentials extends StatelessWidget {
  Credentials({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return const AnimateSignInFields();
  }
}

import 'package:adopt_a_pet/pages/Home/home-screen.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../All-Constants/color_constants.dart';
import '../../All-Constants/global_variable.dart';
import '../../All-Constants/size_constants.dart';
import '../../model/user-model.dart';
import '../../router/Navigate-Route.dart';
import '../../widgets/Loading-Indicator.dart';
import '../../widgets/Toast-Message.dart';
import '../../widgets/animation-item-builder.dart';
import '../../widgets/rectangular_button.dart';
import '../../widgets/rectangular_input_field.dart';
import 'components/header-signin.dart';
import 'components/password-input-field.dart';
import 'components/social.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
part 'signup-controller-extension.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  int itemsCount = 0;
  List<Widget> icon = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  final _auth = FirebaseAuth.instance;

  errorMessage(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  void initState() {
    icon = [
      Center(
        child: Text(
          'Adopt A Pet',
          style: GoogleFonts.acme(
            textStyle: const TextStyle(
                color: AppColors.logoColor,
                letterSpacing: 5,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      const HeaderSignIn("SIGN UP"),
      InputFieldsNameEmail(
        sufixIcon: null,
        controller: nameController,
        textInputType: TextInputType.text,
        hintText: 'Name',
        icon: const Icon(
          Icons.person,
          color: AppColors.logoColor,
        ),
        obscureText: false,
      ),
      InputFieldsNameEmail(
        sufixIcon: null,
        controller: emailController,
        textInputType: TextInputType.emailAddress,
        hintText: 'Email',
        icon: const Icon(
          Icons.email_rounded,
          color: Colors.green,
        ),
        obscureText: false,
      ),
      PasswordInputField(
        passwordController: passwordController,
      ),
      const SizedBox(
        height: Sizes.appPadding / 2,
      ),
      RectangularButton(
          text: 'Sign Up',
          press: () async {
            if (nameController.text.trim().isEmpty) {
              displayErrorMessage("Name is required.");
            } else if (emailController.text.trim().isEmpty) {
              displayErrorMessage("Email is required.");
            } else if (!emailController.text.contains('@')) {
              displayErrorMessage("Invalid email format.");
            } else if (passwordController.text.trim().isEmpty) {
              displayErrorMessage("Password is required.");
            } else {
              startShowLoadingView();
              signUp();
            }
          }),
      const SizedBox(
        height: Sizes.dimen_40 / 2,
      ),
      const Social(
        login: false,
      ),
    ];

    itemsCount = icon.length;

    Future.delayed(Duration(milliseconds: 1000) * 5, () {
      if (!mounted) {
        return;
      }
      setState(() {
        if (icon.length > itemsCount) {
          itemsCount += 6;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: LiveList(
          //physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          showItemInterval: const Duration(milliseconds: 200),
          showItemDuration: const Duration(milliseconds: 400),
          visibleFraction: 0.001,
          itemCount: itemsCount,
          itemBuilder: animationItemBuilder((index) => icon[index])),
    );
  }
}

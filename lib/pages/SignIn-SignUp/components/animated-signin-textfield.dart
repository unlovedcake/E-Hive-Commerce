import 'package:adopt_a_pet/pages/SignIn-SignUp/components/social.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import '../../../widgets/animation-item-builder.dart';
import '../../../widgets/rectangular_button.dart';
import '../signin-screen.dart';
import 'head_text.dart';

class AnimateSignInFields extends StatefulWidget {
  const AnimateSignInFields({Key? key}) : super(key: key);

  @override
  _AnimateSignInFieldsState createState() => _AnimateSignInFieldsState();
}

class _AnimateSignInFieldsState extends State<AnimateSignInFields> {
  int itemsCount = 0;
  List<Widget> icon = [];

  @override
  void initState() {
    icon = [
      const HeadText(),
      const SignInScreen(),
      RectangularButton(
          text: 'Login',
          press: () {
            //NavigateRoute.gotoPage(context, const SignInEmailPassword());
          }),
      //const Social()
    ];

    itemsCount = icon.length;

    Future.delayed(const Duration(milliseconds: 1000) * 5, () {
      if (!mounted) {
        return;
      }
      setState(() {
        if (icon.length > itemsCount) {
          itemsCount += 5;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return LiveList(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        showItemInterval: Duration(milliseconds: 200),
        showItemDuration: const Duration(milliseconds: 750),
        visibleFraction: 0.001,
        itemCount: itemsCount,
        itemBuilder: animationItemBuilder((index) => icon[index]));
  }
}

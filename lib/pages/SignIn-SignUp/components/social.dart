import 'package:adopt_a_pet/pages/SignIn-SignUp/signup-screen.dart';
import 'package:flutter/material.dart';
import '../../../All-Constants/size_constants.dart';
import '../../../router/Navigate-Route.dart';
import '../../../widgets/account_check.dart';
import '../signin-screen.dart';

class Social extends StatelessWidget {
  final bool login;
  const Social({required this.login, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: Sizes.appPadding,
        ),
        AccountCheck(
          login: login,
          press: () {
            if (login) {
              NavigateRoute.routePageAnimation(context, animateRouteSignUpScreen(true));
            } else {
              NavigateRoute.routePageAnimation(context, animateRouteSignUpScreen(false));
            }
          },
        ),
      ],
    );
  }

  Route animateRouteSignUpScreen(bool isSingUp) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 1000),
      pageBuilder: (context, animation, secondaryAnimation) =>
          isSingUp ? const SignUpScreen() : const SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: Tween<double>(
            begin: 0,
            end: 1,
          ).animate(animation),

          // child: SizeTransition(
          //   sizeFactor: animation,
          //   axis: Axis.horizontal,
          //   axisAlignment: -1,
          //     child: Padding(
          //           padding: padding,
          //           child: child(index),
          //         ),
          // ),
          //
          child: Align(
            child: SizeTransition(
              sizeFactor: animation,
              child: child,
              axisAlignment: 0.0,
            ),
          ),

          // child: FadeTransition(
          //   opacity:animation,
          //   child: child,
          // ),

          // child: ScaleTransition(
          //   scale: animation,
          //   child: Padding(
          //     padding:EdgeInsets.all(8),
          //     child: child,
          //   ),
          // ),

          // child: SlideTransition(
          //   position: Tween<Offset>(
          //     begin: Offset(0, -0.1),
          //     end: Offset.zero,
          //   ).animate(animation),
          //   child: Padding(
          //     padding: padding,
          //     child: child(index),
          //   ),
          // ),
        );
        // return SlideTransition(
        //   position: animation.drive(tween),
        //   child: child,
        // );
      },
    );
  }
}

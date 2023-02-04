import 'package:flutter/material.dart';

import '../All-Constants/color_constants.dart';
import '../All-Constants/size_constants.dart';

class NeumorphicTextFieldContainer extends StatelessWidget {
  final Widget child;

  const NeumorphicTextFieldContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: Sizes.appPadding / 2),
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.lightPrimary,
                AppColors.darkPrimary,
              ]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              offset: Offset(-2, -2),
              spreadRadius: 1,
              blurRadius: 4,
              color: AppColors.lightShadow,
            ),
            BoxShadow(
              offset: Offset(2, 2),
              spreadRadius: 1,
              blurRadius: 4,
              color: AppColors.darkShadow,
            ),
          ]),
      child: child,
    );
  }
}

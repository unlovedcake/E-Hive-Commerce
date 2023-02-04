import 'package:flutter/material.dart';

import '../All-Constants/color_constants.dart';
import '../All-Constants/size_constants.dart';



class RectangularButton extends StatelessWidget {
  final String text;
  final VoidCallback press;

  const RectangularButton({Key? key, required this.text, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding:  const EdgeInsets.only(top: Sizes.appPadding,bottom: Sizes.appPadding /2),
        child: Container(
          width: double.infinity,
          height: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.darkPrimary,
                    AppColors.lightPrimary,
                  ]
              ),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(3,3),
                  spreadRadius: 1,
                  blurRadius: 4,
                  color:  AppColors.darkShadow,
                ),
                BoxShadow(
                  offset: Offset(-5,-5),
                  spreadRadius: 1,
                  blurRadius: 4,
                  color:  AppColors.lightShadow,
                ),
              ]
          ),
          child: Center(
            child: Text(text,style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),),
          ),
        ),
      ),
    );
  }
}

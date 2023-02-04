import 'package:flutter/material.dart';

import '../All-Constants/color_constants.dart';
import 'neumorphic_text_field_container.dart';

class InputFieldsNameEmail extends StatelessWidget {
  final String hintText;
  final Icon? icon;
  final bool obscureText;
  final TextInputType textInputType;
  final Widget? sufixIcon;
  final TextEditingController controller;



  const InputFieldsNameEmail(
      {Key? key,


      required this.controller,
      required this.textInputType,
      required this.hintText,
      required this.icon,
      required this.obscureText,
      required this.sufixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicTextFieldContainer(
      child: TextFormField(
        textInputAction: TextInputAction.next,
        controller: controller,
        keyboardType: textInputType,
        cursorColor: Colors.black,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 20),
        decoration: InputDecoration(
          hintText: hintText,
          helperStyle: TextStyle(
            color: AppColors.black.withOpacity(0.7),
            fontSize: 20,
          ),
          suffixIcon: sufixIcon,
          prefixIcon: icon,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

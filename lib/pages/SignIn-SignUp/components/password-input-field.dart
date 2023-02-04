import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../All-Constants/color_constants.dart';
import '../../../widgets/rectangular_input_field.dart';

class PasswordInputField extends StatefulWidget {
  final TextEditingController passwordController;
  const PasswordInputField({required this.passwordController, Key? key}) : super(key: key);

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _isHidden = false;

  @override
  Widget build(BuildContext context) {
    return InputFieldsNameEmail(
      controller: widget.passwordController,
      textInputType: TextInputType.text,
      hintText: 'Password',
      icon: const Icon(
        Icons.lock,
        color: Colors.black,
      ),
      sufixIcon: IconButton(
        icon: Icon(
          _isHidden ? Icons.visibility_off : Icons.visibility,
          color: _isHidden ? AppColors.greyColor : AppColors.logoColor,
        ),
        onPressed: () {
          setState(() {
            _isHidden = !_isHidden;
          });
        },
      ),
      obscureText: !_isHidden,
    );
  }
}

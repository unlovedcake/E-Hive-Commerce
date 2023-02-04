import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../All-Constants/color_constants.dart';
import '../../../widgets/rectangular_input_field.dart';

class TextFormFieldsNameEmail extends StatefulWidget {
  final String? hintText;
  const TextFormFieldsNameEmail(this.hintText, {Key? key}) : super(key: key);

  @override
  State<TextFormFieldsNameEmail> createState() => _TextFormFieldsNameEmailState();
}

class _TextFormFieldsNameEmailState extends State<TextFormFieldsNameEmail> {
  TextEditingController inputValueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InputFieldsNameEmail(
      controller: inputValueController,
      textInputType: TextInputType.text,
      hintText: widget.hintText.toString(),
      icon: const Icon(
        Icons.lock,
        color: Colors.black,
      ),
      sufixIcon: null,
      obscureText: false,
    );
  }
}

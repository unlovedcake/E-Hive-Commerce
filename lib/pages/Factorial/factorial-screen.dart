import 'package:adopt_a_pet/utilities/AssetStorageImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../../All-Constants/color_constants.dart';
import '../../widgets/Toast-Message.dart';
part 'factorial-controller-extension.dart';

class FactorialScreen extends StatefulWidget {
  const FactorialScreen({Key? key}) : super(key: key);

  @override
  State<FactorialScreen> createState() => FactorialScreenState();
}

class FactorialScreenState extends State<FactorialScreen> {
  TextEditingController value = TextEditingController();

  final _inputValue = ValueNotifier<int>(0);

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      print(scrollController.offset);
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text("Factorial",
            style: TextStyle(
              color: AppColors.logoColor,
            )),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                AssetStorageImage.factorial,
                height: size.height * .30,
              ),
              SizedBox(
                height: size.height * .04,
              ),
              ValueListenableBuilder(
                  valueListenable: _inputValue,
                  builder: (parentContext, _, widget1) {
                    return Wrap(
                      children: [
                        Text(
                          _inputValue.value == 0 ? "Enter Number" : "Result is : ",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        _inputValue.value == 0
                            ? const SizedBox.shrink()
                            : FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  _inputValue.value.toString(),
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              ),
                      ],
                    );
                  }),
              SizedBox(
                height: size.height * .05,
              ),
              inputNumberFactorial(),
              SizedBox(
                height: size.height * .05,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: AppColors.logoColor, //<-- SEE HERE
                ),
                onPressed: () {
                  if (value.text.isEmpty) {
                    displayErrorMessage('Please, Input any number.');
                  } else {
                    factorial(int.parse(value.text));
                  }
                },
                child: const Text(
                  'Calculate Factorial',
                  style: TextStyle(fontSize: 20),
                ), // <-- Text
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField inputNumberFactorial() {
    return TextField(
      onChanged: (val) {
        if (val.isEmpty) {
          _inputValue.value = 0;
        }

        // show button calcualte when keyboard is open
        scrollController.animateTo(
          scrollController.position.pixels + 220,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );
      },
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      controller: value,
      decoration: InputDecoration(
        focusedBorder:
            const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        hintText: 'Enter Number...',
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  void displayErrorMessage(String message) {
    ToastMessage.showMessage(message, context,
        offSetBy: 0,
        position: const StyledToastPosition(align: Alignment.topCenter, offset: 200.0),
        isShapedBorder: false);
  }
}

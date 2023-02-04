import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../All-Constants/color_constants.dart';

class HeadText extends StatelessWidget {
  const HeadText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: size.height * 0.05),
          Text(
            'Adopt A Pet',
            style: GoogleFonts.monoton(
              textStyle: const TextStyle(
                  color: AppColors.logoColor,
                  letterSpacing: 5,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          AspectRatio(aspectRatio: 5 / 3, child: Image.asset('asset/images/app-logo.png')),
        ],
      ),
    );
  }
}

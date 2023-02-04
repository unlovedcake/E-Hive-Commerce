import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class ToastMessage {
  static void showMessage(String error, BuildContext context,
      {double offSetBy = 0.0,
      StyledToastPosition position =
          const StyledToastPosition(align: Alignment.bottomCenter, offset: 0.0),
      bool isShapedBorder = true}) async {
    showToast(error,
        textPadding: EdgeInsets.only(top: isShapedBorder ? 0 : 20, bottom: 20, left: 35, right: 35),
        textStyle: const TextStyle(color: Colors.red),
        context: context,
        animation: StyledToastAnimation.slideToBottomFade,
        position: position,
        startOffset: const Offset(0.0, -3.0),
        reverseEndOffset: const Offset(0.0, -3.0),
        duration: const Duration(seconds: 4),
        animDuration: const Duration(seconds: 2),
        curve: Curves.fastLinearToSlowEaseIn,
        reverseCurve: Curves.fastOutSlowIn,
        backgroundColor: Colors.white,
        isHaveBoxShadow: true);
  }
}

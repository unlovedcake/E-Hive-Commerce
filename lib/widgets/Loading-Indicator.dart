import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  String nameLbl = "Checking reuqest. Please wait...";
  double loadingIconWidth = 1;
  Color loadingIconColor = Colors.black;

  LoadingIndicator(
      {super.key,
      this.nameLbl = "Checking request. Please wait...",
      this.loadingIconWidth = 1,
      this.loadingIconColor = Colors.black}); // = Colors.black;

  @override
  State<LoadingIndicator> createState() => _GKLoadingView();
}

class _GKLoadingView extends State<LoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
          elevation: 7,
          backgroundColor: Colors.white,
          content: IntrinsicHeight(
            child: Row(
              children: [
                CircularProgressIndicator(
                    strokeWidth: widget.loadingIconWidth, color: widget.loadingIconColor),
                Container(width: 15),
                Flexible(
                  child: Text(
                    widget.nameLbl,
                    style: const TextStyle(color: Color(0xFF434343), fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                )
              ],
            ),
          )),
    );
  }
}

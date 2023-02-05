import 'package:adopt_a_pet/All-Constants/all_constants.dart';
import 'package:adopt_a_pet/model/product-model.dart';
import 'package:adopt_a_pet/utilities/AssetStorageImage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utilities/Curve-Clipper.dart';

class SelectedItemView extends StatefulWidget {
  final ProductModel dataDetails;
  const SelectedItemView({required this.dataDetails, Key? key}) : super(key: key);

  @override
  State<SelectedItemView> createState() => _SelectedItemViewState();
}

class _SelectedItemViewState extends State<SelectedItemView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var style1 =
        const TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: AppColors.logoColor);
    var style2 = TextStyle(color: Colors.grey.shade500, fontSize: 16);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Product Item',
          style: style1,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: CurveClipper(),
              child: Container(
                padding: const EdgeInsets.all(12),
                width: size.width,
                height: size.height * .55,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: const [
                  BoxShadow(
                    offset: Offset(-5, -5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    color: Colors.white,
                  ),
                ]),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Hero(
                          tag: widget.dataDetails.id.toString(),
                          child: CachedNetworkImage(
                            width: size.width * .48,
                            height: size.height * .28,
                            imageUrl: widget.dataDetails.thumbnail.toString(),
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                CircularProgressIndicator(value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Image.asset(AssetStorageImage.eCommerceLogo),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      widget.dataDetails.title.toString(),
                      style: style1,
                    ),
                    Text(
                      widget.dataDetails.price.toString(),
                      style: style1,
                    ),
                    SizedBox(
                      height: size.height * .02,
                    ),
                    Text(
                      widget.dataDetails.description.toString(),
                      style: style2,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

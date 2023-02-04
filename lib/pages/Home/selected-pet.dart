import 'package:adopt_a_pet/model/pet-model.dart';
import 'package:adopt_a_pet/model/product-model.dart';
import 'package:adopt_a_pet/utilities/AssetStorageImage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utilities/Curve-Clipper.dart';

class SelectedPet extends StatefulWidget {
  final ProductModel petModel;
  const SelectedPet({required this.petModel, Key? key}) : super(key: key);

  @override
  State<SelectedPet> createState() => _SelectedPetState();
}

class _SelectedPetState extends State<SelectedPet> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var style1 = const TextStyle(fontWeight: FontWeight.w500, fontSize: 28, color: Colors.black);
    var style2 = TextStyle(color: Colors.grey.shade500, fontSize: 15);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Pet Profile',
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
                        child: CachedNetworkImage(
                          width: size.width * .48,
                          height: size.height * .28,
                          imageUrl: widget.petModel.thumbnail.toString(),
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              CircularProgressIndicator(value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Image.asset(AssetStorageImage.appLogo),
                        ),
                      ),
                    ),
                    Text(
                      widget.petModel.title.toString(),
                      style: style1,
                    ),
                    Text(
                      widget.petModel.description.toString(),
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

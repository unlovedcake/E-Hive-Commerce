import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ClipRRect circleAvatar(String urlImage) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(50),
    child: CachedNetworkImage(
      imageUrl: urlImage,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(Colors.transparent, BlendMode.colorBurn)),
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    ),
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

RichText? searchHiglightTermText(String suggestion, String highlightedText) {
  int startIndex = suggestion.indexOf(highlightedText);

  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
            text: suggestion.substring(startIndex, startIndex + highlightedText.length),
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20)),
        TextSpan(
            text: suggestion.substring(startIndex + highlightedText.length),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      ],
    ),
  );
}

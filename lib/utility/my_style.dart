import 'package:flutter/material.dart';

import 'my_constant.dart';

class Mystyle {
  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstrant.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      );

  TextStyle h1Style() => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: MyConstrant.primary,
      );
  TextStyle h2Style() => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: MyConstrant.primary,
      );

  TextStyle h3Style() => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: MyConstrant.primary,
      );

  Mystyle();
}

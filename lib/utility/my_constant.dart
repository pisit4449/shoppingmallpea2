import 'package:flutter/material.dart';

class MyConstant {
  // Gernarol
  static String appName = 'Shopping Pupea';

  // Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeBuyerService = '/buyerService';
  static String routeSellerService = '/sellerService';
  static String routeRiderService = '/riderService';

  // Images
  static String image1 = 'images/image1.png';
  static String image2 = 'images/image2.png';
  static String image3 = 'images/image3.png';
  static String image4 = 'images/image4.png';
  static String avatar = 'images/avatar.png';

  // Colos
  static Color primary = Color(0xffff80a9);
  static Color dark = Color(0xffc94f7a);
  static Color light = Color(0xffffb2da);

  // TextStyle
  TextStyle h1_Style() =>
      TextStyle(fontSize: 24, color: dark, fontWeight: FontWeight.bold);
  TextStyle h2_Style() =>
      TextStyle(fontSize: 18, color: dark, fontWeight: FontWeight.w700);
  TextStyle h3_Style() =>
      TextStyle(fontSize: 14, color: dark, fontWeight: FontWeight.normal);

  // ButtonStyle
  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
}

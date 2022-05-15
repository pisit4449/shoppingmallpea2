// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';

class MyConstant {
  // Gernarol
  static String appName = 'Shopping Pupea';
  static String domain = 'https://492d-171-97-111-168.ngrok.io';
  static String urlPrompay = 'https://promptpay.io/0897513041.png';
  static String publicKey = 'pkey_test_5rshhzfs9v5oq3bgcfe';
  static String secreKey = 'skey_test_5rsbc2gdwncw54c0x3o';

  // Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeBuyerService = '/buyerService';
  static String routeSellerService = '/sellerService';
  static String routeRiderService = '/riderService';
  static String routeAddProduct = '/addProduct';
  static String routeEditProfileSeller = '/editProfileSeller';
  static String routeShowCart = '/showCart';
  static String routeAddWallet = '/addWallet';
  static String routeConfirmAddWallet = '/confirmAddWallet';

  // Images
  static String image1 = 'images/image1.png';
  static String image2 = 'images/image2.png';
  static String image3 = 'images/image3.png';
  static String image4 = 'images/image4.png';
  static String image5 = 'images/image5.png';
  static String avatar = 'images/avatar.png';
  static String bankKT = 'images/bbl.png';
  static String bankKbank = 'images/kbank.png';

  // Colos
  static Color primary = Color(0xffff80a9);
  static Color dark = Color(0xffc94f7a);
  static Color light = Color(0xffffb2da);

  static Map<int, Color> mapMaterialColor = {
    50: Color.fromRGBO(255, 255, 128, 0.1),
    100: Color.fromRGBO(255, 255, 128, 0.2),
    200: Color.fromRGBO(255, 255, 128, 0.3),
    300: Color.fromRGBO(255, 255, 128, 0.4),
    400: Color.fromRGBO(255, 255, 128, 0.5),
    500: Color.fromRGBO(255, 255, 128, 0.6),
    600: Color.fromRGBO(255, 255, 128, 0.7),
    700: Color.fromRGBO(255, 255, 128, 0.8),
    800: Color.fromRGBO(255, 255, 128, 0.9),
    900: Color.fromRGBO(255, 255, 128, 1.0),
  };
  // backgroud
  BoxDecoration planBackground() =>
      BoxDecoration(color: MyConstant.light.withOpacity(0.75));
  BoxDecoration gradianLinearBackground() => BoxDecoration(
        gradient: LinearGradient(
          end: Alignment.bottomCenter,
          begin: Alignment.topCenter,
          colors: [Colors.white, MyConstant.light, MyConstant.primary],
        ),
      );

  BoxDecoration gradientRadioBackground() => BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.5),
          radius: 1.5,
          colors: [Colors.white, MyConstant.primary],
        ),
      );

  // TextStyle
  TextStyle h1_Style() =>
      TextStyle(fontSize: 24, color: dark, fontWeight: FontWeight.bold);
       TextStyle h1White_Style() =>
      TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold);
  TextStyle h1red_Style() => TextStyle(
      fontSize: 24, color: Colors.red.shade700, fontWeight: FontWeight.bold);
  TextStyle h2_Style() =>
      TextStyle(fontSize: 18, color: dark, fontWeight: FontWeight.w700);
  TextStyle h2White_Style() =>
      TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700);
  TextStyle h2Red_Style() =>
      TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.w700);
  TextStyle h2blue_Style() =>
      TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.w700);
  TextStyle h3_Style() =>
      TextStyle(fontSize: 14, color: dark, fontWeight: FontWeight.normal);
  TextStyle h3White_Style() => TextStyle(
      fontSize: 14, color: Colors.white, fontWeight: FontWeight.normal);

  // ButtonStyle
  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
}

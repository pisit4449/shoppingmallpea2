import 'package:flutter/material.dart';

class MyConstant {
  // Gernarol
  static String appName = 'Shopping Pupea';
  static String domain = 'https://44e5-27-145-154-4.ngrok.io';

  // Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeBuyerService = '/buyerService';
  static String routeSellerService = '/sellerService';
  static String routeRiderService = '/riderService';
  static String routeAddProduct = '/addProduct';
  static String routeEditProfileSeller = '/editProfileSeller';

  // Images
  static String image1 = 'images/image1.png';
  static String image2 = 'images/image2.png';
  static String image3 = 'images/image3.png';
  static String image4 = 'images/image4.png';
  static String image5 = 'images/image5.png';
  static String avatar = 'images/avatar.png';

  // Colos
  static Color primary = Color(0xffff80a9);
  static Color dark = Color(0xffc94f7a);
  static Color light = Color(0xffffb2da);
  
  static Map<int, Color> mapMaterialColor = {
    50:Color.fromRGBO(255, 255, 128, 0.1),
    100:Color.fromRGBO(255, 255, 128, 0.2),
    200:Color.fromRGBO(255, 255, 128, 0.3),
    300:Color.fromRGBO(255, 255, 128, 0.4),
    400:Color.fromRGBO(255, 255, 128, 0.5),
    500:Color.fromRGBO(255, 255, 128, 0.6),
    600:Color.fromRGBO(255, 255, 128, 0.7),
    700:Color.fromRGBO(255, 255, 128, 0.8),
    800:Color.fromRGBO(255, 255, 128, 0.9),
    900:Color.fromRGBO(255, 255, 128, 1.0),
  };


  // TextStyle
  TextStyle h1_Style() =>
      TextStyle(fontSize: 24, color: dark, fontWeight: FontWeight.bold);
  TextStyle h2_Style() =>
      TextStyle(fontSize: 18, color: dark, fontWeight: FontWeight.w700);
  TextStyle h2White_Style() =>
      TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700);
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

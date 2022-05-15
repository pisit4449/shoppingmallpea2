import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmallpea2/states/add_product.dart';
import 'package:shoppingmallpea2/states/add_wallet.dart';
import 'package:shoppingmallpea2/states/authen.dart';
import 'package:shoppingmallpea2/states/buyer_service.dart';
import 'package:shoppingmallpea2/states/confirm_add_wallet.dart';
import 'package:shoppingmallpea2/states/create_account.dart';
import 'package:shoppingmallpea2/states/edit_profile_seller.dart';
import 'package:shoppingmallpea2/states/rider_service.dart';
import 'package:shoppingmallpea2/states/seller_service.dart';
import 'package:shoppingmallpea2/states/show_cart.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/widgets/nev_confirm_add_wallet.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/buyerService': (BuildContext context) => BuyerService(),
  '/sellerService': (BuildContext context) => SellerService(),
  '/riderService': (BuildContext context) => RiderService(),
  '/addProduct': (BuildContext context) => AddProduct(),
  '/editProfileSeller': (BuildContext context) => EditProfileSeller(),
  '/showCart':(BuildContext context) => ShowCart(),
  MyConstant.routeAddWallet:(BuildContext context) => AddWallet(),
  MyConstant.routeConfirmAddWallet:(BuildContext context) => ConfirmAddWallet(),
};

String? initialRoute;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? type = preferences.getString('type');
  print('### type ====>> $type');
  if (type?.isEmpty ?? true) {
    initialRoute = MyConstant.routeAuthen;
    runApp(MyApp());
  } else {
    switch (type) {
      case 'buyer':
        initialRoute = MyConstant.routeBuyerService;
        runApp(MyApp());
        break;
      case 'seller':
        initialRoute = MyConstant.routeSellerService;
        runApp(MyApp());
        break;
      case 'rider':
        initialRoute = MyConstant.routeRiderService;
        runApp(MyApp());
        break;
        break;
      default:
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColor =
        MaterialColor(0xffff80a9, MyConstant.mapMaterialColor);
    return MaterialApp(
      routes: map,
      title: MyConstant.appName,
      initialRoute: initialRoute,
      theme: ThemeData(primarySwatch: materialColor),
      // theme: ThemeData(primaryColor: MyConstant.light),
    );
  }
}

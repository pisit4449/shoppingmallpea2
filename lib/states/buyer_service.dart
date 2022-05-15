// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmallpea2/bodys/my_money_buyer.dart';
import 'package:shoppingmallpea2/bodys/my_order_buyer.dart';
import 'package:shoppingmallpea2/bodys/show_all_shop_buyer.dart';
import 'package:shoppingmallpea2/models/user_model.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/utility/my_dialog.dart';
import 'package:shoppingmallpea2/widgets/show_image.dart';
import 'package:shoppingmallpea2/widgets/show_progress.dart';
import 'package:shoppingmallpea2/widgets/show_signout.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class BuyerService extends StatefulWidget {
  const BuyerService({Key? key}) : super(key: key);

  @override
  State<BuyerService> createState() => _BuyerServiceState();
}

class _BuyerServiceState extends State<BuyerService> {
  List<Widget> widgets = [
    ShowAllShopbuyer(),
    MyMoneyBuyer(),
    MyOrderBuyer(),
  ];
  int indexWidget = 0;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    findUserLogin();
  }

  Future<void> findUserLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var idUserLogin = preferences.getString('id');
    // print('### idUserLognin ==> $idUserLogin');
    var urlAPi =
        '${MyConstant.domain}/shoppingmallnew/getUserWhereId.php?isAdd=true&id=$idUserLogin';
    await Dio().get(urlAPi).then((value) async {
      for (var item in json.decode(value.data)) {
        print('item ==> $item');
        setState(() {
          userModel = UserModel.fromMap(item);
        });
      }

      var path =
          '${MyConstant.domain}/shoppingmallnew/getWalletWhereIdBuyer.php?isAdd=true&idBuyer=${userModel!.id}';
      await Dio().get(path).then((value) {
        print('#### value ===> $value');

        if (value.toString() == 'null') {
          print('#### Action alert add Wallet');
          MyDialog(
            funcAction: () {
              Navigator.pop(context());
              Navigator.pushNamed(context(), MyConstant.routeAddWallet);
            },
          ).actionDialog(context(), 'No Wallet', 'Please Add Wallet');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, MyConstant.routeShowCart),
            icon: Icon(Icons.shopping_cart_outlined),
          ),
        ],
        title: Text('Buyer'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildHeader(),
                menuShowAllShop(),
                menuMyMoney(),
                menuShowMyOrder(),
              ],
            ),
            ShowSignOut(),
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
  }

  ListTile menuShowAllShop() {
    return ListTile(
      leading: Icon(Icons.shopping_bag_outlined, color: MyConstant.dark),
      title:
          ShowTitle(title: 'Show All shop', textStyle: MyConstant().h2_Style()),
      subtitle: ShowTitle(
          title: 'แสดงร้านค้าทั้งหมด', textStyle: MyConstant().h3_Style()),
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context());
        });
      },
    );
  }

  ListTile menuMyMoney() {
    return ListTile(
      leading: Icon(Icons.money, color: MyConstant.dark),
      title: ShowTitle(title: 'My Money', textStyle: MyConstant().h2_Style()),
      subtitle: ShowTitle(
          title: 'แสดงจำนวนเงินที่มี', textStyle: MyConstant().h3_Style()),
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context());
        });
      },
    );
  }

  ListTile menuShowMyOrder() {
    return ListTile(
      leading: Icon(Icons.list, color: MyConstant.dark),
      title: ShowTitle(title: 'My Order', textStyle: MyConstant().h2_Style()),
      subtitle: ShowTitle(
          title: 'แสดงรายการสั่งของ', textStyle: MyConstant().h3_Style()),
      onTap: () {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context());
        });
      },
    );
  }

  UserAccountsDrawerHeader buildHeader() => UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 0.8,
          center: Alignment(-0.7, -0.2),
          colors: [Colors.white, MyConstant.dark],
        ),
      ),
      currentAccountPicture: userModel == null
          ? ShowImage(path: MyConstant.image3)
          : userModel!.avatar.isEmpty
              ? ShowImage(path: MyConstant.image3)
              : CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      '${MyConstant.domain}${userModel!.avatar}'),
                ),
      accountName: ShowTitle(
        title: userModel == null ? '' : userModel!.name,
        textStyle: MyConstant().h2White_Style(),
      ),
      accountEmail: null);
}

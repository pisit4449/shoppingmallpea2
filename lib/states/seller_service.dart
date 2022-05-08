import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmallpea2/bodys/shop_manage_seller.dart';
import 'package:shoppingmallpea2/bodys/show_Product_seller.dart';
import 'package:shoppingmallpea2/bodys/show_order_seller.dart';
import 'package:shoppingmallpea2/models/user_model.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/widgets/show_progress.dart';
import 'package:shoppingmallpea2/widgets/show_signout.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class SellerService extends StatefulWidget {
  const SellerService({Key? key}) : super(key: key);

  @override
  State<SellerService> createState() => _SellerServiceState();
}

class _SellerServiceState extends State<SellerService> {
  List<Widget> widgets = [];
  int indexWidget = 0;
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUserModel();
  }

  Future<Null> findUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    print('### id Login ==> $id');
    String apiGetUserWhereId =
        '${MyConstant.domain}/shoppingmallnew/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(apiGetUserWhereId).then((value) {
      print('## value ==> $value');
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          // print('### name login = ${userModel!.name}');
          widgets.add(ShowOrderSeller());
          widgets.add(ShopManageSeller(userModel: userModel!));
          widgets.add(ShowProductSeller());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller'),
      ),
      drawer: widgets.length == 0
          ? SizedBox()
          : Drawer(
              child: Stack(
                children: [
                  ShowSignOut(),
                  // ignore: prefer_const_constructors
                  Column(
                    children: [
                      buildHead(),
                      menuShowOrder(),
                      menuShopManage(),
                      menuShowProduct(),
                    ],
                  ),
                ],
              ),
            ),
      body: widgets.length == 0 ? ShowProgress() : widgets[indexWidget],
    );
  }

  UserAccountsDrawerHeader buildHead() {
    return UserAccountsDrawerHeader(
        otherAccountsPictures: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.face_outlined,
              size: 36,
              color: MyConstant.light,
            ),
          ),
        ],
        decoration: BoxDecoration(
          gradient: RadialGradient(
              colors: [MyConstant.light, MyConstant.dark],
              center: Alignment(-0.8, -0.2),
              radius: 0.5),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundImage:
              NetworkImage('${MyConstant.domain}${userModel!.avatar}'),
        ),
        accountName: Text(userModel == null ? 'Name?' : userModel!.name),
        accountEmail: Text(userModel == null ? 'Type?' : userModel!.type));
  }

  ListTile menuShowOrder() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context());
        });
      },
      tileColor: Colors.pink.shade100,
      subtitle: ShowTitle(
          title: 'แสดงรายละเอียด Order ที่ลูกค้าสั่ง',
          textStyle: MyConstant().h3_Style()),
      title: ShowTitle(title: 'ShowOrder', textStyle: MyConstant().h2_Style()),
      leading: Icon(Icons.filter_1_outlined, color: MyConstant.dark),
    );
  }

  ListTile menuShopManage() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context());
        });
      },
      tileColor: Colors.pink.shade50,
      subtitle: ShowTitle(
          title: 'แสดงรายละเอียดของร้านค้าให้ลูกค้าเห็น',
          textStyle: MyConstant().h3_Style()),
      title: ShowTitle(title: 'ShopManage', textStyle: MyConstant().h2_Style()),
      leading: Icon(Icons.filter_2_outlined, color: MyConstant.dark),
    );
  }

  ListTile menuShowProduct() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context());
        });
      },
      tileColor: Colors.pink.shade100,
      subtitle: ShowTitle(
          title: 'แสดงรายละเอียดของสินค้าให้เราขาย',
          textStyle: MyConstant().h3_Style()),
      title:
          ShowTitle(title: 'ShowProduct', textStyle: MyConstant().h2_Style()),
      leading: Icon(Icons.filter_3_outlined, color: MyConstant.dark),
    );
  }
}

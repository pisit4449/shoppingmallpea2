import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmallpea2/bodys/shop_manage_seller.dart';
import 'package:shoppingmallpea2/bodys/show_Product_seller.dart';
import 'package:shoppingmallpea2/bodys/show_order_seller.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/widgets/show_signout.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class SellerService extends StatefulWidget {
  const SellerService({Key? key}) : super(key: key);

  @override
  State<SellerService> createState() => _SellerServiceState();
}

class _SellerServiceState extends State<SellerService> {
  List<Widget> widgets = [
    ShowOrderSeller(),
    ShopManageSeller(),
    ShowProductSeller()
  ];
  int indexWidget = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            ShowSignOut(),
            // ignore: prefer_const_constructors
            Column(
              children: [
                UserAccountsDrawerHeader(accountName: null, accountEmail: null),
                menuShowOrder(),
                menuShopManage(),
                menuShowProduct(),
              ],
            ),
          ],
        ),
      ),body: widgets[indexWidget],
    );
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

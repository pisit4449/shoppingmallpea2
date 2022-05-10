

import 'package:flutter/material.dart';
import 'package:shoppingmallpea2/bodys/my_money_buyer.dart';
import 'package:shoppingmallpea2/bodys/my_order_buyer.dart';
import 'package:shoppingmallpea2/bodys/show_all_shop_buyer.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
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

  UserAccountsDrawerHeader buildHeader() =>
      UserAccountsDrawerHeader(accountName: null, accountEmail: null);
}

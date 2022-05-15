// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_brace_in_string_interps, unused_local_variable

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmallpea2/models/sqlite_model.dart';
import 'package:shoppingmallpea2/models/user_model.dart';
import 'package:shoppingmallpea2/models/wallet_model.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/utility/my_dialog.dart';
import 'package:shoppingmallpea2/utility/sqlite_helper.dart';
import 'package:shoppingmallpea2/widgets/show_image.dart';
import 'package:shoppingmallpea2/widgets/show_nodata.dart';
import 'package:shoppingmallpea2/widgets/show_progress.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class ShowCart extends StatefulWidget {
  const ShowCart({Key? key}) : super(key: key);

  @override
  State<ShowCart> createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<SQLiteModel> sqliteModels = [];
  bool load = true;
  UserModel? userModel;
  int? total;

  @override
  void initState() {
    super.initState();
    processReadSQLite();
  }

  Future<Null> processReadSQLite() async {
    if (sqliteModels.isNotEmpty) {
      sqliteModels.clear();
    }

    await SQLiteHelper().readSQLite().then((value) {
      setState(() {
        load = false;
        sqliteModels = value;
        findDetailSeller();
        calculateTotal();
      });
    });
  }

  void calculateTotal() async {
    total = 0;
    for (var item in sqliteModels) {
      int sumInt = int.parse(item.sum.trim());
      setState(() {
        total = total! + sumInt;
      });
    }
  }

  Future<void> findDetailSeller() async {
    String idSeller = sqliteModels[0].idSeller;
    print('### id Seller ==> $idSeller');
    String apiGetUserWhereId =
        '${MyConstant.domain}/shoppingmallnew/getUserWhereId.php?isAdd=true&id=$idSeller';
    await Dio().get(apiGetUserWhereId).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Show Cart'),
        ),
        body: load
            ? ShowProgress()
            : sqliteModels.isEmpty
                ? ShowNoData(
                    title: 'Emty Cart',
                    pathImage: MyConstant.image2,
                  )
                : buildContent());
  }

  Container buildContent() {
    return Container(
      decoration: MyConstant().gradianLinearBackground(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showSeller(),
          buildHead(),
          listProduct(),
          buildDivider(),
          buildTotal(),
          buttonController(),
        ],
      ),
    );
  }

  Future<void> confirmEmptyCart() async {
    print('### confirmEmptyCart Work');
    showDialog(
        context: context(),
        builder: (context) => AlertDialog(
              title: ListTile(
                leading: ShowImage(path: MyConstant.image3),
                title: ShowTitle(
                  title: 'ลบรายการทั้งหมด ?',
                  textStyle: MyConstant().h2_Style(),
                ),
                subtitle: ShowTitle(
                  title: 'ลบ Product ทั้้งหมดในตะกร้า',
                  textStyle: MyConstant().h3_Style(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await SQLiteHelper().emptySQLite().then((value) {
                      Navigator.pop(context);
                      processReadSQLite();
                    });
                  },
                  child: Text('Delete'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancle'),
                )
              ],
            ));
  }

  Row buttonController() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () async {
            // Navigator.pushNamed(context(), MyConstant.routeAddWallet);
            MyDialog().showProgressDialog(context());

            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            String idBuyer = preferences.getString('id')!;

            var path =
                '${MyConstant.domain}/shoppingmallnew/getWalletWhereIdBuyer.php?isAdd=true&idBuyer=${idBuyer}';
            await Dio().get(path).then((value) {
              Navigator.pop(context());
              if (value.toString() == 'null') {
                print('#### Action alert add Wallet');
                MyDialog(
                  funcAction: () {
                    Navigator.pop(context());
                    Navigator.pushNamed(context(), MyConstant.routeAddWallet);
                  },
                ).actionDialog(context(), 'No Wallet', 'Please Add Wallet');
              } else {
                print('####check Wallet can Payment');

                int approveWallet = 0;
                for (var item in json.decode(value.data)) {
                  WalletModel walletModel = WalletModel.fromMap(item);
                  if (walletModel.status == 'Approve') {
                    approveWallet =
                        approveWallet + int.parse(walletModel.money.trim());
                  }
                }
                print('#12feb approveWallet ==>$approveWallet');
                if (approveWallet - total! >= 0) {
                  print('#12feb Can Order');
                  MyDialog(funcAction: orderFunc).actionDialog(context(), 'Confirm Order?', 'Order Total : $total thb \n Please Confirm Order');
                } else {
                  print('#12feb Cannot Order');
                  MyDialog().normalDialog(context(), 'Cannot Order?',
                      'Approve Money : $approveWallet \n Total : $total \n จำนวนเงินไม่พอจ่าย ต้องรอ Admin Approve ก่อน หรือ Add Money เพิ่ม');
                }
              }
            });
          },
          child: Text('Order'),
        ),
        Container(
          margin: EdgeInsets.only(left: 4, right: 8),
          child: ElevatedButton(
            onPressed: () => confirmEmptyCart(),
            child: Text('Empty Cart'),
          ),
        ),
      ],
    );
  }

  Row buildTotal() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShowTitle(
                title: 'Total  :  ',
                textStyle: MyConstant().h2blue_Style(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShowTitle(
                title: total == null ? '' : total.toString(),
                textStyle: MyConstant().h1_Style(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Divider buildDivider() {
    return Divider(
      color: MyConstant.dark,
    );
  }

  ListView listProduct() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: sqliteModels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ShowTitle(
                title: sqliteModels[index].name,
                textStyle: MyConstant().h3_Style(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ShowTitle(
              title: sqliteModels[index].price,
              textStyle: MyConstant().h3_Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowTitle(
              title: sqliteModels[index].amount,
              textStyle: MyConstant().h3_Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowTitle(
              title: sqliteModels[index].sum,
              textStyle: MyConstant().h3_Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () async {
                int idSQLite = sqliteModels[index].id!;
                print('### Delete idSQLite ==> $idSQLite');
                await SQLiteHelper()
                    .deleteSQLiteWhereId(idSQLite)
                    .then((value) => processReadSQLite());
              },
              icon: Icon(
                Icons.delete_forever,
                color: Colors.red.shade700,
                size: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildHead() {
    return Container(
      decoration: BoxDecoration(color: MyConstant.light),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ShowTitle(
                  title: 'Product',
                  textStyle: MyConstant().h2_Style(),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ShowTitle(
                title: 'Price',
                textStyle: MyConstant().h2_Style(),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: 'Amt',
                textStyle: MyConstant().h2_Style(),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: 'Sum',
                textStyle: MyConstant().h2_Style(),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Padding showSeller() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShowTitle(
        title: userModel == null ? '' : userModel!.name,
        textStyle: MyConstant().h1_Style(),
      ),
    );
  }

  Future<void> orderFunc()async {
    Navigator.pop(context());
    print('orderFunc Work');

  }
}

import 'dart:convert';
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shoppingmallpea2/models/product_model.dart';
import 'package:shoppingmallpea2/models/sqlite_model.dart';
import 'package:shoppingmallpea2/models/user_model.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/utility/my_dialog.dart';
import 'package:shoppingmallpea2/utility/sqlite_helper.dart';
import 'package:shoppingmallpea2/widgets/show_image.dart';
import 'package:shoppingmallpea2/widgets/show_progress.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class ShowProductBuyer extends StatefulWidget {
  final UserModel userModel;
  const ShowProductBuyer({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ShowProductBuyer> createState() => _ShowProductBuyerState();
}

class _ShowProductBuyerState extends State<ShowProductBuyer> {
  UserModel? userModel;
  bool load = true;
  bool? haveProduct;
  List<ProductModel> productModels = [];
  List<List<String>> listImages = [];
  int indexImage = 0;
  int amountInt = 1;
  String? currentIdSeller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    readAPI();
    readCart();
  }

  Future<Null> readCart() async {
    await SQLiteHelper().readSQLite().then((value) {
      if (value.length != 0) {
        List<SQLiteModel> models = [];
        for (var model in value) {
          models.add(model);
        }
        currentIdSeller = models[0].idSeller;
        print('### currentIdSeller = $currentIdSeller');
      }
    });
  }

  Future<void> readAPI() async {
    String urlAPI =
        '${MyConstant.domain}/shoppingmallnew/getProductWhereIdSeller.php?isAdd=true&idSeller=${userModel!.id}';
    await Dio().get(urlAPI).then((value) {
      // print('### value ==> $value');

      if (value.toString() == 'null') {
        setState(() {
          haveProduct = false;
          load = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          ProductModel model = ProductModel.fromMap(item);

          String string = model.images;
          string = string.substring(1, string.length - 1);
          List<String> stirngs = string.split(',');
          int i = 0;
          for (var item in stirngs) {
            stirngs[i] = item.trim();
            i++;
          }
          listImages.add(stirngs);

          setState(() {
            haveProduct = true;
            load = false;
            productModels.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userModel!.name),
      ),
      body: load
          ? ShowProgress()
          : haveProduct!
              ? listProduct()
              : Center(
                  child: ShowTitle(
                    title: 'No Product',
                    textStyle: MyConstant().h1_Style(),
                  ),
                ),
    );
  }

  LayoutBuilder listProduct() {
    return LayoutBuilder(
      builder: (context, constraints) => ListView.builder(
        itemCount: productModels.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            // print('## You Click Index ==> $index');
            showAlertDialog(
              productModels[index],
              listImages[index],
            );
          },
          child: Card(
            child: Row(
              children: [
                Container(
                  height: constraints.maxWidth * 0.4,
                  width: constraints.maxWidth * 0.5 - 8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: findUrlImage(productModels[index].images),
                      placeholder: (context, url) => ShowProgress(),
                      errorWidget: (context, url, error) =>
                          ShowImage(path: MyConstant.image1),
                    ),
                  ),
                ),
                Container(
                  height: constraints.maxWidth * 0.4,
                  width: constraints.maxWidth * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShowTitle(
                            title: productModels[index].name,
                            textStyle: MyConstant().h2_Style()),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ShowTitle(
                              title: 'Price ${productModels[index].price} THB',
                              textStyle: MyConstant().h3_Style()),
                        ),
                        ShowTitle(
                            title: cutWord(
                                'Detail::  ${productModels[index].detail}'),
                            textStyle: MyConstant().h3_Style()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String findUrlImage(String arrayImages) {
    String string = arrayImages.substring(1, arrayImages.length - 1);
    List<String> strings = string.split(',');
    int index = 0;
    for (var item in strings) {
      strings[index] = item.trim();
      index++;
    }
    String result = '${MyConstant.domain}/shoppingmallnew${strings[0]}';
    return result;
  }

  Future<Null> showAlertDialog(
      ProductModel productModel, List<String> images) async {
    showDialog(
        context: context(),
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: ListTile(
                  leading: ShowImage(path: MyConstant.image2),
                  title: ShowTitle(
                      title: productModel.name,
                      textStyle: MyConstant().h2_Style()),
                  subtitle: ShowTitle(
                      title: 'Price : ${productModel.price} THB',
                      textStyle: MyConstant().h3_Style()),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            '${MyConstant.domain}/shoppingmallnew${images[indexImage]}',
                        placeholder: (context, url) => ShowProgress(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    indexImage = 0;
                                    print('### indexImage = $indexImage');
                                  });
                                },
                                icon: Icon(
                                  Icons.filter_1,
                                  color: MyConstant.dark,
                                )),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    indexImage = 1;
                                    print('### indexImage = $indexImage');
                                  });
                                },
                                icon: Icon(
                                  Icons.filter_2,
                                  color: MyConstant.dark,
                                )),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    indexImage = 2;
                                    print('### indexImage = $indexImage');
                                  });
                                },
                                icon: Icon(
                                  Icons.filter_3,
                                  color: MyConstant.dark,
                                )),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    indexImage = 3;
                                    print('### indexImage = $indexImage');
                                  });
                                },
                                icon: Icon(
                                  Icons.filter_4,
                                  color: MyConstant.dark,
                                )),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          ShowTitle(
                              title: 'รายละเอียด :',
                              textStyle: MyConstant().h2_Style()),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 200,
                              child: ShowTitle(
                                  title: productModel.detail,
                                  textStyle: MyConstant().h3_Style()),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                if (amountInt != 1) {
                                  setState(() {
                                    amountInt--;
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color: MyConstant.dark,
                              )),
                          ShowTitle(
                              title: amountInt.toString(),
                              textStyle: MyConstant().h1_Style()),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  amountInt++;
                                });
                              },
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: MyConstant.dark,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () async {
                          String idSeller = userModel!.id;
                          String idProduct = productModel.id;
                          String name = productModel.name;
                          String price = productModel.price;
                          String amount = amountInt.toString();
                          int sumInt = int.parse(price) * amountInt;
                          String sum = sumInt.toString();

                          print(
                              '### idSeller ==> $idSeller , idProduct ==> $idProduct, name => $name, price => $price, amount => $amount, sum => $sum');
                          
                          if ((currentIdSeller == idSeller) || (currentIdSeller == null)) {
                            SQLiteModel sqLiteModel = SQLiteModel(
                                idSeller: idSeller,
                                idProduct: idProduct,
                                name: name,
                                price: price,
                                amount: amount,
                                sum: sum);
                            await SQLiteHelper()
                                .insertValueToSQLite(sqLiteModel)
                                .then((value) {
                              amountInt = 1;
                              Navigator.pop(context);
                            });
                          } else {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            MyDialog().normalDialog(context, 'ร้านผิด',
                                'กรุณาเลือกสินค้าที่ร้านเดิม ให้เสร็จก่อนเลือกร้านอื่นค่ะ');
                          }
                        },
                        child: Text(
                          'Add Cart',
                          style: MyConstant().h2blue_Style(),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancle',
                          style: MyConstant().h2Red_Style(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }

  String cutWord(String string) {
    String result = string;
    if (result.length >= 100) {
      result = result.substring(0, 100);
      result = '$result ...';
    }
    return result;
  }
}

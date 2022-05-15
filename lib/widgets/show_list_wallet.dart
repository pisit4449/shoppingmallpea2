import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmallpea2/models/wallet_model.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/widgets/show_image.dart';
import 'package:shoppingmallpea2/widgets/show_progress.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class showListWallet extends StatelessWidget {
  const showListWallet({
    Key? key,
    required this.walletMOdels,
  }) : super(key: key);

  final List<WalletModel>? walletMOdels;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: walletMOdels!.length,
        itemBuilder: (context, index) => Card(
          color: index % 2 == 0
              ? MyConstant.light.withOpacity(0.5)
              : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShowTitle(
                      title: walletMOdels![index].money,
                      textStyle: MyConstant().h1_Style(),
                    ),
                    Container(
                      width: 150,
                      height: 170,
                      child: CachedNetworkImage(
                          placeholder: (context, url) => ShowProgress(),
                          errorWidget: (context, url, error) =>
                              ShowImage(path: 'images/bill.png'),
                          imageUrl:
                              '${MyConstant.domain}/shoppingmallnew${walletMOdels![index].pathSlip}'),
                    ),
                  ],
                ),
                ShowTitle(
                  title: walletMOdels![index].datePay,
                  textStyle: MyConstant().h2_Style(),
                )
              ],
            ),
          ),
        ),
      );
  }
}
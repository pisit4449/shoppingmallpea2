// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:shoppingmallpea2/models/wallet_model.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/widgets/show_list_wallet.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class Wait extends StatefulWidget {
  final List<WalletModel> walletModels;
  const Wait({Key? key, required this.walletModels}) : super(key: key);

  @override
  State<Wait> createState() => _WaitState();
}

class _WaitState extends State<Wait> {
  List<WalletModel>? waitWalletModels;

  @override
  void initState() {
    super.initState();
    waitWalletModels = widget.walletModels;
    print('### waitWallet list ==> ${waitWalletModels!.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: waitWalletModels?.isEmpty ?? true
          ? Center(
              child: ShowTitle(
              title: 'No Wait Wallet',
              textStyle: MyConstant().h1red_Style(),
            ))
          : showListWallet(walletMOdels: waitWalletModels),
    );
  }
}

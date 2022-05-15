// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_print, camel_case_types

import 'package:flutter/material.dart';
import 'package:shoppingmallpea2/models/wallet_model.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/widgets/show_list_wallet.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class Approve extends StatefulWidget {
  final List<WalletModel> walletModels;
  const Approve({Key? key, required this.walletModels}) : super(key: key);

  @override
  State<Approve> createState() => _ApproveState();
}

class _ApproveState extends State<Approve> {
  List<WalletModel>? approveWalletModels;

  @override
  void initState() {
    super.initState();
    approveWalletModels = widget.walletModels;
    print('### approve list ==> ${approveWalletModels!.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: approveWalletModels?.isEmpty ?? true
          ? ShowTitle(
              title: 'No Money Approve',
              textStyle: MyConstant().h1_Style(),
            )
          : showListWallet(walletMOdels: approveWalletModels,),
    );
  }
}

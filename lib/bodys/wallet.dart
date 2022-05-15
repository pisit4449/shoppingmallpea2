// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class Wallet extends StatefulWidget {
  final int approveWallet, waitApproveWallet;
  const Wallet({
    Key? key,
    required this.approveWallet,
    required this.waitApproveWallet,
  }) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  int? approveWallet, waitApproveWallet;

  @override
  void initState() {
    super.initState();
    this.approveWallet = widget.approveWallet;
    this.waitApproveWallet = widget.waitApproveWallet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: MyConstant().planBackground(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              newListile(
                  Icons.wallet_giftcard, 'จำนวนเงินที่ใช้ได้', '$approveWallet thb'),
              newListile(
                  Icons.wallet_membership, 'จำนวนเงินรอตรวจสอบ', '$waitApproveWallet thb'),
              newListile(Icons.grading_sharp, 'จำนวนเงินทั้งหมด', '${(approveWallet! + waitApproveWallet!)} thb'),
            ],
          ),
        ),
      ),
    );
  }

  Widget newListile(IconData iconData, String title, String subTitle) {
    return Container(
      width: 300,
      child: Card(
        color: MyConstant.light.withOpacity(0.15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: ListTile(
            leading: Icon(iconData, color: Colors.white, size: 40),
            title: ShowTitle(
              title: title,
              textStyle: MyConstant().h2White_Style(),
            ),
            subtitle: ShowTitle(
              title: subTitle,
              textStyle: MyConstant().h1red_Style(),
            ),
          ),
        ),
      ),
    );
  }
}

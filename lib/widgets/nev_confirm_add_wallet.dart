import 'package:flutter/material.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/widgets/show_image.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class NaviConfrimAddWallet extends StatelessWidget {
  const NaviConfrimAddWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      // height: 80,
      child: InkWell(
        onTap: () => Navigator.pushNamedAndRemoveUntil(
            context, MyConstant.routeConfirmAddWallet, (route) => false),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('images/bill.png'),
                ShowTitle(title: 'Confirm'),
              ],
            ),
          ),
          color: MyConstant.light,
        ),
      ),
    );
  }
}

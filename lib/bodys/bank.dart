import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/widgets/show_image.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class Bank extends StatefulWidget {
  const Bank({Key? key}) : super(key: key);

  @override
  State<Bank> createState() => _BankState();
}

class _BankState extends State<Bank> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildTitle(),
            ListTile(
              // leading: SvgPicture.asset('images/bbl.svg'),
              leading: Container(
                width: 80,
                height: 80,
                child: ShowImage(path: MyConstant.bankKT),
              ),
              title: ShowTitle(
                title: 'ธนาคารกรุงเทพ สาขาบิ๊กซี บางนา',
                textStyle: MyConstant().h2_Style(),
              ),
              subtitle: ShowTitle(
                title:
                    'ชื่อบัญชี นายชัยวุฒิ พรหมบุตร เลขบัญชี 913 - 0 - 04149 - 5',
                textStyle: MyConstant().h3_Style(),
              ),
            )
          ],
        ),
      ),
    );
  }

  ShowTitle buildTitle() {
    return ShowTitle(
      title: 'การโอนเงินเข้าบัญชีธนาคาร',
      textStyle: MyConstant().h1_Style(),
    );
  }
}

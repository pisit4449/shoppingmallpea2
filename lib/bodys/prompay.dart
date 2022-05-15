import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/utility/my_dialog.dart';
import 'package:shoppingmallpea2/widgets/nev_confirm_add_wallet.dart';
import 'package:shoppingmallpea2/widgets/show_progress.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class Prompay extends StatefulWidget {
  const Prompay({Key? key}) : super(key: key);

  @override
  State<Prompay> createState() => _PrompayState();
}

class _PrompayState extends State<Prompay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildTitle(),
            buildCopyPrompay(),
            buildQRcodePrompay(),
            buildDownload(),
          ],
        ),
      ),
      floatingActionButton: NaviConfrimAddWallet(),
    );
  }

  ElevatedButton buildDownload() {
    return ElevatedButton(
      onPressed: () async {
        String path = '/sdcard/download';

        try {
          await FileUtils.mkdir([path]);
          await Dio().download(MyConstant.urlPrompay, '$path/prompay.png').then(
              (value) => MyDialog().normalDialog(
                  context(),
                  'Download Prompay Finish',
                  'กรุณาไปที่แอพธนาคาร เพื่อนอ่าน QRcode'));
        } catch (e) {
          print('### error ==> ${e.toString()}');
          MyDialog().normalDialog(context(), 'Storage Permission Denied',
              'กรุณาเปิด Permission Storage  ด้วยค่ะ');
        }
      },
      child: Text('Download QRcode'),
    );
  }

  Container buildQRcodePrompay() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: CachedNetworkImage(
        imageUrl: MyConstant.urlPrompay,
        placeholder: (context, url) => ShowProgress(),
      ),
    );
  }

  Widget buildCopyPrompay() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        color: Colors.lime.shade100,
        child: ListTile(
          title: ShowTitle(
            title: '0897513041',
            textStyle: MyConstant().h1_Style(),
          ),
          subtitle: ShowTitle(title: 'บัญชี Prompay'),
          trailing: IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: '0897513041'));
              MyDialog().normalDialog(context(), 'Copy Prompay',
                  'Copy Prompay to Clipboard เสร็จแล้วกรุณาไปที่แอพธนาคารของท่านเพื่อโอนเงินผ่าน  Prompay ได้เลยครับ');
            },
            icon: Icon(
              Icons.copy,
              color: MyConstant.dark,
            ),
          ),
        ),
      ),
    );
  }

  ShowTitle buildTitle() {
    return ShowTitle(
      title: 'การโอนเงินโดยวิธี Prompay',
      textStyle: MyConstant().h2_Style(),
    );
  }
}

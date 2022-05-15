import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/utility/my_dialog.dart';
import 'package:shoppingmallpea2/widgets/show_image.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class ConfirmAddWallet extends StatefulWidget {
  const ConfirmAddWallet({Key? key}) : super(key: key);

  @override
  State<ConfirmAddWallet> createState() => _ConfirmAddWalletState();
}

class _ConfirmAddWalletState extends State<ConfirmAddWallet> {
  String? dateTimeStr;
  File? file;
  var formKey = GlobalKey<FormState>();
  String? idBuyer;
  TextEditingController moneyController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    findCurrentTime();
    findIdBuyer();
  }

  Future<void> findIdBuyer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idBuyer = preferences.getString('id');
  }

  void findCurrentTime() {
    DateTime dateTime = DateTime.now();

    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    setState(() {
      dateTimeStr = dateFormat.format(dateTime);
    });
    print('### datTimeStr = $dateTimeStr');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('confirm Add Wallet'),
        leading: IconButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context, MyConstant.routeBuyerService, (route) => false),
          icon: Platform.isIOS
              ? Icon(Icons.arrow_back_ios)
              : Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(
            FocusNode(),
          ),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeadTitle(),
                buildNameDateTimePay(),
                Spacer(),
                buildMoney(),
                Spacer(),
                buildImage(),
                Spacer(),
                buildButtomConfirm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildMoney() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250,
          child: TextFormField(
            controller: moneyController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill MOney';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              label: ShowTitle(title: 'Money'),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Container buildButtomConfirm() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            if (file == null) {
              MyDialog().normalDialog(
                  context(), 'ยังไม่มีรูปภาพ', 'กรุณาอัพโหลดภาพก่อน');
            } else {
              processUploadAndInsertData();
            }
          }
        },
        child: Text('Confirm Add Wallet'),
      ),
    );
  }

  Future<void> processUploadAndInsertData() async {
    // Upload Image to Server
    String apiSaveSlip = '${MyConstant.domain}/shoppingmallnew/saveSlip.php';
    String nameSlip = 'slip${Random().nextInt(1000000)}.jpg';
    MyDialog().showProgressDialog(context());
    try {
      Map<String, dynamic> map = {};
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameSlip);
      FormData data = FormData.fromMap(map);
      await Dio().post(apiSaveSlip, data: data).then((value) async {
        print('### value ==> $value');
        Navigator.pop(context());

        // Insert value to mySQL
        var pathSlip = '/slip/$nameSlip';
        var status = 'WaitOrder';
        var urlAPIinsert =
            '${MyConstant.domain}/shoppingmallnew/insertWallet.php?isAdd=true&idBuyer=$idBuyer&datePay=$dateTimeStr&money=${moneyController.text.trim()}&pathSlip=$pathSlip&status=$status';
        await Dio().get(urlAPIinsert).then((value) => MyDialog(funcAction: success).actionDialog(
              context(),
              'Confirm Success',
              'Confirm Add Money to Wallet Success',
            ));
      });
    } catch (e) {}
  }

  void success (){
    Navigator.pushNamedAndRemoveUntil(context(),MyConstant.routeBuyerService , (route) => false);
    print('Success Work');
  }

  Future<void> processTakePhoto(ImageSource source) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildImage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () => processTakePhoto(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            size: 40,
            color: MyConstant.dark,
          ),
        ),
        Container(
          width: 200,
          height: 200,
          child: file == null
              ? ShowImage(path: 'images/bill.png')
              : Image.file(file!),
        ),
        IconButton(
            onPressed: () => processTakePhoto(ImageSource.gallery),
            icon: Icon(Icons.add_photo_alternate,
                size: 40, color: MyConstant.dark)),
      ],
    );
  }

  ShowTitle buildNameDateTimePay() {
    return ShowTitle(
        title: dateTimeStr == null ? 'dd/MM/yy HH:mm' : dateTimeStr!,
        textStyle: MyConstant().h2blue_Style());
  }

  ShowTitle buildHeadTitle() {
    return ShowTitle(
        title: 'Current Date Pay', textStyle: MyConstant().h1_Style());
  }
}

import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:omise_flutter/omise_flutter.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/utility/my_dialog.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

import 'package:http/http.dart' as http;

class Credic extends StatefulWidget {
  const Credic({Key? key}) : super(key: key);

  @override
  State<Credic> createState() => _CredicState();
}

class _CredicState extends State<Credic> {
  String? name,
      surname,
      idCard,
      expiryDateMouth,
      expiryDateYear,
      cvc,
      amount,
      expriyDateStr;
  MaskTextInputFormatter idCardMask =
      MaskTextInputFormatter(mask: '#### - #### - #### - ####');
  MaskTextInputFormatter expiryDateMask =
      MaskTextInputFormatter(mask: '## / ####');
  MaskTextInputFormatter cvcMask = MaskTextInputFormatter(mask: '###');
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitle('name  Surname'),
                    buildNameSurname(),
                    buildTitle('ID Card'),
                    buildFormIdCard(),
                    buildExpiryCvc(),
                    buildTitle('Anount :'),
                    buildFormAmount(),
                    // Spacer(),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buildButtonAddMoney(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildButtonAddMoney() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            getTokenAndChargeOmise();
          }
        },
        child: Text('Add Money'),
      ),
    );
  }

  Future<void> getTokenAndChargeOmise() async {
    String publicKey = MyConstant.publicKey;

    print(
        '###name = $name, surname = $surname, publicKey ==> $publicKey, value idCard ==> $idCard, expiryDateMouthMonth ==> $expiryDateMouth, year ==> $expiryDateYear, cvc ==> $cvc');

    OmiseFlutter omiseFlutter = OmiseFlutter(publicKey);
    await omiseFlutter.token
        .create(
            '$name $surname', idCard!, expiryDateMouth!, expiryDateYear!, cvc!)
        .then((value) async {
      String token = value.id.toString();
      print('### token =======> $token');

      String secredKey = MyConstant.secreKey;
      String urlAPI = 'https://api.omise.co/charges';
      String basciAuth = 'Basic ' + base64Encode(utf8.encode(secredKey + ":"));

      Map<String, String> headerMap = {};
      headerMap['authorization'] = basciAuth;
      headerMap['Cache-Control'] = 'no-cache';
      headerMap['Content-Type'] = 'application/x-www-form-urlencoded';
      String zero = '00';
      amount = '$amount$zero';
      print('### mount00 ==> $amount');

      Map<String, dynamic> data = {};
      data['amount'] = amount;
      data['currency'] = 'thb';
      data['card'] = token;
      Uri uri = Uri.parse(urlAPI);

      http.Response response = await http.post(
        uri,
        headers: headerMap,
        body: data,
      );

      var resultCharge = json.decode(response.body);
      // print('### resultCharge = $resultCharge');
      print('status ของการตัดบัตร =====>> ${resultCharge['status']}');

    }).catchError((value) {
      String title = value.code;
      String message = value.message;
      MyDialog().normalDialog(context(), title, message);
    });
  }

  Container buildExpiryCvc() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          buildSizeBox(30),
          Expanded(
              child: Column(
            children: [
              buildTitle('Expiry Date :'),
              buildFormExpryDate(),
            ],
          )),
          buildSizeBox(8),
          Expanded(
              child: Column(
            children: [
              buildTitle('CVC :'),
              buildFormCVC(),
            ],
          )),
          buildSizeBox(30),
        ],
      ),
    );
  }

  Container buildNameSurname() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          buildSizeBox(30),
          buildFormName(),
          buildSizeBox(8),
          buildFormSurName(),
          buildSizeBox(30),
        ],
      ),
    );
  }

  SizedBox buildSizeBox(double width) => SizedBox(width: width);

  Widget buildFormAmount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Amount in Blank';
          } else {
            amount = value.trim();
            return null;
          }
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          suffix: ShowTitle(
            title: 'THB.',
            textStyle: MyConstant().h2_Style(),
          ),
          label: ShowTitle(title: 'Amount :'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget buildFormExpryDate() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Fill Expiry Date in Blank';
        } else {
          if (expriyDateStr!.length != 6) {
            return 'กรุณากรอกให้ถูกต้อง';
          } else {
            expiryDateMouth = expriyDateStr!.substring(0, 2);
            expiryDateYear = expriyDateStr!.substring(2, 6);

            int expiryDateMountInt = int.parse(expiryDateMouth!);
            expiryDateMouth = expiryDateMountInt.toString();

            if (expiryDateMountInt > 12) {
              return 'ไม่มีเดือนที่เกิน 12';
            } else {
              return null;
            }
          }
        }
      },
      onChanged: (value) {
        expriyDateStr = expiryDateMask.getUnmaskedText();
      },
      inputFormatters: [expiryDateMask],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'xx/xxxx',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget buildFormCVC() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Fill CVC in Blank';
        } else {
          if (cvc!.length != 3) {
            return 'กรุณากรอกให้ถูกต้อง';
          } else {
            return null;
          }
        }
      },
      onChanged: (value) {
        cvc = cvcMask.getUnmaskedText();
      },
      inputFormatters: [cvcMask],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'xxx',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget buildFormIdCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill IDCard in Blank';
          } else {
            if (idCard!.length != 16) {
              return 'ID Card ต้องมี 16 ตัวอักษร';
            } else {
              return null;
            }
          }
        },
        inputFormatters: [idCardMask],
        onChanged: (value) {
          // idCard = value.trim();
          idCard = idCardMask.getUnmaskedText();
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'xxxx-xxxx-xxxx-xxxx',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget buildFormName() {
    return Expanded(
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Name in Blank';
          } else {
            name = value.trim();
            return null;
          }
        },
        decoration: InputDecoration(
          label: ShowTitle(
            title: 'Name :',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget buildFormSurName() {
    return Expanded(
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Surname in Blank';
          } else {
            surname = value.trim();
            return null;
          }
        },
        decoration: InputDecoration(
          label: ShowTitle(title: 'Surname :'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShowTitle(
        title: title,
        textStyle: MyConstant().h2blue_Style(),
      ),
    );
  }
}

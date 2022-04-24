import 'dart:io';
// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/widgets/show_image.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String? typeUser;
  File? file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng()async{
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Service Location Open');
      
      locationPermission = await Geolocator.checkPermission();
          if (locationPermission == LocationPermission.denied) {
              locationPermission = await Geolocator.requestPermission();
              if (locationPermission == LocationPermission.deniedForever) {
                  // MyDialog().alertLocationService(context, 'ไม่อนุญาตแชร์ Location', 'โปรดแชร์ Location');
              } else {
                findLatLng();
              }
          } else {
            if (locationPermission == LocationPermission.deniedForever) {
              // MyDialog().alertLocationService(context, 'ไม่อนุญาตแชร์ Location', 'โปรดแชร์ Location');
            } else {
            }
          }


    } else {
      print('Service Location Close');
      // MyDialog().alertLocationService(context(), 'Location ของคุณปิดอยู่', 'กรุณาเปิด Location Service');
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primary,
        title: Text('Create New Account'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          buildTitle('ข้อมูลทั่วไป'),
          buildName(size),
          buildTitle('ชนิด User'),
          buildRadioBuyer(size),
          buildRadioSeller(size),
          buildRadioRider(size),
          buildAddress(size),
          buildUser(size),
          buildPhone(size),
          buildPassword(size),
          buildPicture(),
          buildAvatar(size),
        ],
      ),
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildAvatar(double size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            color: MyConstant.dark,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: size * 0.6,
          child: file == null
              ? ShowImage(path: MyConstant.avatar)
              : Image.file(file!),
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: Icon(Icons.add_photo_alternate),
          color: MyConstant.dark,
          iconSize: 36,
        )
      ],
    );
  }

  Row buildPicture() {
    return Row(
      children: [
        buildTitle('รูปภาพ'),
        ShowTitle(
          title: ' (รูปภาพมีรูป Default)',
          textStyle: MyConstant().h3_Style(),
        ),
      ],
    );
  }

  Row buildPhone(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size * 0.7,
          child: TextFormField(
            decoration: InputDecoration(
              labelStyle: MyConstant().h3_Style(),
              labelText: 'Phone :',
              prefixIcon: Icon(
                Icons.phone,
                color: MyConstant.dark,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.primary),
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size * 0.7,
          child: TextFormField(
            decoration: InputDecoration(
              labelStyle: MyConstant().h3_Style(),
              labelText: 'User :',
              prefixIcon: Icon(
                Icons.account_balance,
                color: MyConstant.dark,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.primary),
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size * 0.7,
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password :',
              labelStyle: MyConstant().h3_Style(),
              prefixIcon: Icon(
                Icons.lock_clock_outlined,
                color: MyConstant.dark,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.primary),
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildAddress(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size * 0.7,
          child: TextFormField(
            maxLines: 4,
            decoration: InputDecoration(
              hintStyle: MyConstant().h3_Style(),
              hintText: 'Address :',
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                child: Icon(
                  Icons.home,
                  color: MyConstant.dark,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: MyConstant.primary),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRadioBuyer(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.7,
          child: RadioListTile(
            activeColor: MyConstant.dark,
            title: ShowTitle(
              title: 'Buyer (ผู้ซื้อ)',
              textStyle: MyConstant().h2_Style(),
            ),
            value: 'buyer',
            groupValue: typeUser,
            onChanged: (value) {
              setState(() {
                typeUser = value as String?;
              });
            },
          ),
        ),
      ],
    );
  }

  Row buildRadioSeller(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.7,
          child: RadioListTile(
            title: ShowTitle(
              title: 'Seller (ผู้ขาย)',
              textStyle: MyConstant().h2_Style(),
            ),
            value: 'seller',
            groupValue: typeUser,
            onChanged: (value) {
              setState(() {
                typeUser = value as String?;
              });
            },
          ),
        ),
      ],
    );
  }

  Row buildRadioRider(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.7,
          child: RadioListTile(
            title: ShowTitle(
              title: 'Rider (ผู้ส่ง)',
              textStyle: MyConstant().h2_Style(),
            ),
            value: 'rider',
            groupValue: typeUser,
            onChanged: (value) {
              setState(() {
                typeUser = value as String?;
              });
            },
          ),
        ),
      ],
    );
  }

  Row buildName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size * 0.6,
          child: TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.fingerprint,
                color: MyConstant.dark,
              ),
              labelStyle: MyConstant().h3_Style(),
              labelText: 'Name : ',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: MyConstant.primary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: MyConstant.dark),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container buildTitle(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ShowTitle(
        title: title,
        textStyle: MyConstant().h2_Style(),
      ),
    );
  }
}

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shoppingmallpea2/models/user_model.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/widgets/show_progress.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class ShopManageSeller extends StatefulWidget {
  final UserModel userModel;

  const ShopManageSeller({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ShopManageSeller> createState() => _ShopManageSellerState();
}

class _ShopManageSellerState extends State<ShopManageSeller> {
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
  }

  Future<Null> refreshUserModel() async {
    print('##refreshUserModel Work');
    String apiGetUserWhereId = '${MyConstant.domain}/shoppingmallnew/getUserWhereId.php?isAdd=true&id=${userModel!.id}';
    await Dio().get(apiGetUserWhereId).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.primary,
        child: Icon(Icons.edit),
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routeEditProfileSeller)
                .then(
          (value) => refreshUserModel(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShowTitle(
                    title: 'Name Shop :', textStyle: MyConstant().h2_Style()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShowTitle(
                          title: userModel!.name,
                          textStyle: MyConstant().h1_Style()),
                    ),
                  ],
                ),
                ShowTitle(
                    title: 'Address :', textStyle: MyConstant().h2_Style()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: constraints.maxWidth * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ShowTitle(
                            title: userModel!.address,
                            textStyle: MyConstant().h2_Style()),
                      ),
                    ),
                  ],
                ),
                ShowTitle(
                    title: 'Phone :   ${userModel!.phone}',
                    textStyle: MyConstant().h2_Style()),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ShowTitle(
                      title: 'Avatar : ', textStyle: MyConstant().h2_Style()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: constraints.maxWidth * 0.6,
                      child: CachedNetworkImage(
                        imageUrl: '${MyConstant.domain}${userModel!.avatar}',
                        placeholder: (context, url) => ShowProgress(),
                      ),
                    ),
                  ],
                ),
                ShowTitle(
                    title: 'Location', textStyle: MyConstant().h2_Style()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: constraints.maxWidth * 0.6,
                      height: constraints.maxWidth * 0.6,
                      child: GoogleMap(
                        markers: <Marker>[
                          Marker(
                            markerId: MarkerId('id'),
                            position: LatLng(
                              double.parse(userModel!.lat),
                              double.parse(userModel!.lng),
                            ),
                            infoWindow: InfoWindow(
                              title: 'You Here',
                              snippet:
                                  'lat = ${userModel!.lat}, lng = ${userModel!.lng}',
                            ),
                          )
                        ].toSet(),
                        initialCameraPosition: CameraPosition(
                          zoom: 16,
                          target: LatLng(
                            double.parse(userModel!.lat),
                            double.parse(userModel!.lng),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

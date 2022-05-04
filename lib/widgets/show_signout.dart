import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class ShowSignOut extends StatelessWidget {
  const ShowSignOut({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear().then(
                  (value) => Navigator.pushNamedAndRemoveUntil(
                      context, MyConstant.routeAuthen, (route) => false),
                );
          },
          tileColor: Colors.red.shade900,
          subtitle: ShowTitle(
              title: 'SignOut And  Go To Authen',
              textStyle: MyConstant().h3White_Style()),
          title: ShowTitle(
              title: 'Sign OUt', textStyle: MyConstant().h2White_Style()),
          leading: Icon(Icons.exit_to_app, color: Colors.white),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shoppingmallpea2/widgets/show_signout.dart';

class BuyerService extends StatefulWidget {
  const BuyerService({Key? key}) : super(key: key);

  @override
  State<BuyerService> createState() => _BuyerServiceState();
}

class _BuyerServiceState extends State<BuyerService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ShowSignOut(),
      ),
      appBar: AppBar(
        title: Text('Buyer'),
      ),
    );
  }
}

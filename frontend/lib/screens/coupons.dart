import 'package:flutter/material.dart';

class Coupons extends StatefulWidget {
  @override
  _CouponsState createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            "assets/coupon_screen.png",
            fit: BoxFit.fitWidth,
          )),
    );
  }
}

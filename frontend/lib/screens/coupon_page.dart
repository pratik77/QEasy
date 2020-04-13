import 'package:covidpass/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CouponPage extends StatefulWidget {
  @override
  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gift Cards",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 16 / 10,
                children: <Widget>[
                  _buildMenuItem(
                      "assets/vectors/ic_fitness.svg", "Health & Fitness"),
                  _buildMenuItem("assets/vectors/ic_salon.svg", "Salon & Spa"),
                  _buildMenuItem(
                      "assets/vectors/ic_restaurant.svg", "Restaurants"),
                  _buildMenuItem("assets/vectors/ic_grocery.svg", "Grocery"),
                  _buildMenuItem("assets/vectors/ic_medicine.svg", "Medicines"),
                  _buildMenuItem("assets/vectors/ic_others.svg", "Others"),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: CouponsBgColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Snap Fitness",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          color: SecondaryTextColor,
                          height: 2,
                          width: 75,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "6 Months Membership\nworth Rs. 5999",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              "assets/vectors/ic_stopwatch.svg",
                              color: Colors.black,
                              height: 16,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Valid till 12th june",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "VIEW DETAILS",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              "BUY NOW",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                        child: Image.asset(
                      "assets/fitness_coupon.png",
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String iconPath, String title) {
    return Container(
      decoration: BoxDecoration(color: GiftItemColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(iconPath),
          SizedBox(
            height: 8,
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:covidpass/enums/store_category.dart';
import 'package:covidpass/models/merchant.dart';
import 'package:covidpass/provider/home_notifier.dart';
import 'package:covidpass/screens/coupon_page.dart';
import 'package:covidpass/screens/shop_detail_page.dart';
import 'package:covidpass/utils/colors.dart';
import 'package:covidpass/utils/constants.dart';
import 'package:covidpass/utils/location_utils.dart';
import 'package:covidpass/utils/merchant_utils.dart';
import 'package:covidpass/utils/shared_pref.dart';
import 'package:covidpass/widgets/shadow_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/model.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StoreCategory _currentCategory = StoreCategory.ALL;
  bool _locationLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeNotifier>(
      builder: (context, notifier, child) => SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/vectors/location_pin.svg",
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: notifier.isRequestFinished
                        ? InkWell(
                            child: notifier.currentAddress != null
                                ? Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "${notifier.currentAddress.addressLine}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Icon(Icons.keyboard_arrow_down),
                                    ],
                                  )
                                : Text("Location Service Disabled"),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => StatefulBuilder(
                                        builder: (context, setState) =>
                                            AlertDialog(
                                          title: Text(
                                            "Fetch the current location",
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            height: 200,
                                            width: 200,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(Icons.location_searching),
                                                SizedBox(
                                                  height: 16,
                                                ),
                                                Visibility(
                                                    visible: _locationLoading,
                                                    child:
                                                        CircularProgressIndicator()),
                                                SizedBox(
                                                  height: 16,
                                                ),
                                                RaisedButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      _locationLoading = true;
                                                    });
                                                    LocationData locationData =
                                                        await LocationUtils
                                                            .getCurrentLocation();

                                                    notifier
                                                        .getLocationByLatLong(
                                                            locationData
                                                                .latitude,
                                                            locationData
                                                                .longitude);
                                                    SharedPrefUtils.setDouble(
                                                        Constants.LAT,
                                                        locationData.latitude);
                                                    SharedPrefUtils.setDouble(
                                                        Constants.LONG,
                                                        locationData.longitude);
                                                    setState(() {
                                                      _locationLoading = false;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Get Current Location",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ));
                            },
                          )
                        : LinearProgressIndicator(),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Icon(Icons.search),
                ],
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              color: TabBackgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _buildTabItem(StoreCategory.ALL),
                  _buildTabItem(StoreCategory.GROCERIES),
                  _buildTabItem(StoreCategory.MEDICINES),
                  _buildTabItem(StoreCategory.MEAT),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Stores around you",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: notifier.isRequestFinished
                  ? notifier.merchants != null
                      ? ListView(
                          children: <Widget>[
                            ...notifier.merchants
                                .where((it) =>
                                    it.shopCategory == _currentCategory ||
                                    _currentCategory == StoreCategory.ALL)
                                .map((merchant) => _buildStoreItem(merchant))
                                .toList()
                          ],
                        )
                      : Center(
                          child: Text("No nearby merchants available"),
                        )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                color: CouponsBgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Exciting Coupons",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Save your Local businesses\nby buying service coupons",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CouponPage(),
                            ),
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              "KNOW MORE",
                              style: TextStyle(
                                fontSize: 12,
                                color: ErrorColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: ErrorColor,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Image.asset(
                    "assets/coupon_logo.png",
                    height: 150,
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(StoreCategory category) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentCategory = category;
        });
      },
      child: Container(
        decoration: _currentCategory == category
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: CardShadowColor,
                    blurRadius: 1.5,
                    spreadRadius: 0.5,
                  ),
                ],
              )
            : null,
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          category.toString().split(".")[1],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStoreItem(Merchant merchant) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreDetailPage(merchant),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
        child: ShadowCard(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Hero(
                  tag: merchant.merchantId,
                  child: SvgPicture.asset(
                    MerchantUtils.getImageForMerchant(merchant.shopCategory),
                    width: 82,
                    height: 82,
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        merchant.shopName,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            "assets/vectors/ic_store_location.svg",
                            height: 14,
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: FutureBuilder<List<Address>>(
                              future: LocationUtils.getLocationFromCoordinates(
                                  double.parse(merchant.lat),
                                  double.parse(merchant.lng)),
                              builder: (context, snapshot) => snapshot
                                          .connectionState ==
                                      ConnectionState.waiting
                                  ? Center(
                                      child: LinearProgressIndicator(),
                                    )
                                  : snapshot.hasData && snapshot.data != null
                                      ? Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "${snapshot.data.first.addressLine}",
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: SecondaryTextColor),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          "${merchant.lat}, ${merchant.lng}",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: SecondaryTextColor),
                                        ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.group,
                            size: 14,
                            color: SecondaryLightTextColor,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "Slot Size",
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: SecondaryTextColor),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            merchant.maxPeoplePerSlot,
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: SecondaryTextColor),
                          )
                        ],
                      ),
                      /* SizedBox(height: 8.0),
                      Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            "assets/vectors/ic_clock.svg",
                            height: 14,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "Next available time slots",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: SecondaryTextColor,
                            ),
                          )
                        ],
                      ), */
                      SizedBox(height: 8.0),
                      /* Row(
                        children: <Widget>[
                          SizedBox(width: 20.0),
                          Text(
                            merchant.slots[0],
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            " | ",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            merchant.slots[1],
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ), */
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

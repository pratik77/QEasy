import 'dart:math';

import 'package:covidpass/models/gift_item.dart';
import 'package:covidpass/models/merchant.dart';
import 'package:covidpass/models/slot_book_request.dart';
import 'package:covidpass/models/slot_info.dart';
import 'package:covidpass/provider/merchant_detail_notifier.dart';
import 'package:covidpass/repository/data_repository.dart';
import 'package:covidpass/screens/slot_booking_success.dart';
import 'package:covidpass/utils/code_snippets.dart';
import 'package:covidpass/utils/colors.dart';
import 'package:covidpass/utils/constants.dart';
import 'package:covidpass/utils/date_utils.dart';
import 'package:covidpass/utils/merchant_utils.dart';
import 'package:covidpass/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class StoreDetailPage extends StatefulWidget {
  final Merchant merchant;

  StoreDetailPage(this.merchant);

  @override
  _StoreDetailPageState createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage>
    with SingleTickerProviderStateMixin {
  SlotInfo _selectedSlot;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isSubmitted = false;
  int _currentTab = 0;
  TabController _controller;
  List<String> couponBgs = [
    "assets/coupon_item_1.png",
    "assets/coupon_item_2.png",
    "assets/coupon_item_3.png"
  ];
  bool buyingFinished = true;
  int _slotViewFlexCount = 1;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          _currentTab = _controller.index;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MerchantDetailNotifier>(
      create: (context) => MerchantDetailNotifier(
        widget.merchant.merchantId,
        SharedPrefUtils.get(Constants.USER_ID),
        double.parse(widget.merchant.lat),
        double.parse(widget.merchant.lng),
      ),
      child: Consumer<MerchantDetailNotifier>(
        builder: (context, notifier, child) => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: <Widget>[
                    Hero(
                      tag: widget.merchant.merchantId,
                      child: SvgPicture.asset(
                        MerchantUtils.getImageForMerchant(
                            widget.merchant.shopCategory),
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
                            widget.merchant.shopName,
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
                                child: Text(
                                  notifier.currentAddress != null
                                      ? notifier.currentAddress.addressLine
                                      : "Location Disabled",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: SecondaryTextColor),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Get Direction",
                              style: TextStyle(
                                fontSize: 12,
                                color: PrimaryColor,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Allocation: ${widget.merchant.maxPeoplePerSlot} Customers at a time",
                  style: TextStyle(
                    color: SecondaryLightTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 56,
                width: MediaQuery.of(context).size.width,
                color: TabBackgroundColor,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TabBar(
                  indicatorColor: Colors.transparent,
                  controller: _controller,
                  tabs: <Widget>[
                    _buildTabItem(0),
                    _buildTabItem(1),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _controller,
                  children: [
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            padding: EdgeInsets.all(8),
                            child: widget.merchant.items.length > 0
                                ? GridView.count(
                                    crossAxisCount: 3,
                                    shrinkWrap: true,
                                    childAspectRatio: 3.0,
                                    children: <Widget>[
                                      ...widget.merchant.items.map(
                                        (it) => Row(
                                          children: <Widget>[
                                            Text(
                                              "${String.fromCharCode(0x2022)} ",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: SecondaryLightTextColor,
                                              ),
                                            ),
                                            Text(
                                              it.itemValue,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: SecondaryLightTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child:
                                        Text("No Item information available"),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Expanded(
                          flex: _slotViewFlexCount,
                          child: Container(
                            decoration: BoxDecoration(
                              color: CouponsBgColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 16,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (_slotViewFlexCount == 1) {
                                      setState(() {
                                        _slotViewFlexCount = 2;
                                      });
                                    } else {
                                      setState(() {
                                        _slotViewFlexCount = 1;
                                      });
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        "Select Time Slot",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            "${DateUtils.getFormattedDateInWords(DateTime.now())}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 14,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    child: notifier.isRequestFinished
                                        ? notifier.availableSlots != null
                                            ? GridView.count(
                                                childAspectRatio: 3.5,
                                                crossAxisCount: 2,
                                                shrinkWrap: true,
                                                children: <Widget>[
                                                  ...notifier.availableSlots
                                                      .map((slot) =>
                                                          _buildSlotItem(
                                                              notifier, slot)),
                                                ],
                                              )
                                            : Center(
                                                child:
                                                    Text("No available Slots"),
                                              )
                                        : Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 21, horizontal: 54),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: PrimaryDarkColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(24),
                                      topRight: Radius.circular(24),
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () => _bookSlot(),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "BOOK SLOT",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Visibility(
                                          visible: _isSubmitted,
                                          child: Container(
                                            margin: EdgeInsets.only(left: 8),
                                            child: SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                backgroundColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      child: notifier.giftItems != null &&
                              notifier.giftItems.length > 0
                          ? ListView.builder(
                              itemCount: notifier.giftItems.length,
                              itemBuilder: (context, position) =>
                                  _buildCouponItem(
                                      notifier.giftItems[position]),
                            )
                          : Center(
                              child: Text("No Gift Card available"),
                            ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(CodeSnippets.makeSnackBar(message));
  }

  Widget _buildTabItem(int position) {
    return Container(
      decoration: _currentTab == position
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
        position == 0 ? "AVAILABLE ITEMS" : "GIFT CARDS",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSlotItem(MerchantDetailNotifier notifier, SlotInfo slot) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedSlot = slot;
          print(slot.toJson());
        });
      },
      child: Container(
        margin: EdgeInsets.all(8),
        height: 56,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _selectedSlot == slot ? PrimaryColor : null,
          borderRadius: BorderRadius.all(Radius.circular(6)),
          border: _selectedSlot == slot ? null : Border.all(),
        ),
        child: Text(
          "${slot.startTime}:00 - ${slot.endTime}:00",
          style: TextStyle(
            color: _selectedSlot == slot ? Colors.white : PrimaryTextColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  _bookSlot() {
    if (_selectedSlot == null) {
      _showSnackBar("Select a slot");
      return;
    }
    setState(() {
      _isSubmitted = true;
    });
    DataRepository.instance
        .bookSlot((SlotBookRequest()
              ..startTime = _selectedSlot.startTime
              ..endTime = _selectedSlot.endTime
              ..bookingDate = _selectedSlot.date
              ..merchantId = widget.merchant.merchantId
              ..userId = SharedPrefUtils.get(Constants.USER_ID))
            .toJson())
        .then((response) {
      if (response.responseCode == "200" && response.hasError == "false") {
        SharedPrefUtils.setInt(
            Constants.BOOKED_SLOT_ID, response.data["slotId"]);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SlotBookingSuccess(response.data["slotId"])),
        );
      } else {
        setState(() {
          _isSubmitted = false;
        });
      }
    }).catchError((e) {
      setState(() {
        _isSubmitted = false;
      });
      print(e.message);
    });
  }

  _buildCouponItem(GiftItem giftItem) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(getRandonCouponBg()),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  giftItem.giftName,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/vectors/ic_stopwatch.svg",
                      color: Colors.white,
                      height: 16,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Valid till 12th june",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
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
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    InkWell(
                      onTap: () => _buyCoupon(giftItem.giftId),
                      child: Text(
                        "BUY NOW",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Visibility(
                      visible: !buyingFinished,
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String getRandonCouponBg() {
    return couponBgs[Random().nextInt(couponBgs.length - 1)];
  }

  _buyCoupon(int giftId) async {
    setState(() {
      buyingFinished = false;
    });

    DataRepository.instance.buyGift({
      "userId": SharedPrefUtils.get(Constants.USER_ID),
      "giftId": giftId
    }).then((response) {
      if (response.responseCode == "200" && response.hasError == "false") {
        setState(() {
          buyingFinished = true;
        });
        _showDialog(true);
      }
    }).catchError((e) {
      setState(() {
        buyingFinished = false;
      });
      print(e.message);
    });
  }

  _showDialog(bool isSuccess) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          content: Container(
            height: 200,
            width: 200,
            child: isSuccess
                ? Column(
                    children: <Widget>[
                      SvgPicture.asset("assets/vectors/ic_correct.svg"),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Gift Card purchased successfully",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      Icon(
                        Icons.clear,
                        size: 48,
                        color: ErrorColor,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Gift Card purchased failed",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

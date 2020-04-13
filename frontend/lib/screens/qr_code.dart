import 'package:covidpass/provider/slot_notifier.dart';
import 'package:covidpass/utils/colors.dart';
import 'package:covidpass/utils/constants.dart';
import 'package:covidpass/utils/date_utils.dart';
import 'package:covidpass/utils/shared_pref.dart';
import 'package:covidpass/widgets/shadow_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCode extends StatefulWidget {
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> with SingleTickerProviderStateMixin {
  int _currentTab = 0;
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTab = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SlotNotifier>(
      builder: (context, notifier, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("QR Code"),
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              color: TabBackgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                tabs: <Widget>[
                  _buildTabItem(Constants.UPCOMING_SLOT, 0),
                  _buildTabItem(Constants.PAST_SLOT, 1),
                ],
              ),
            ),
            Expanded(
              child: notifier.isRequestFinished
                  ? notifier.bookedSlot != null
                      ? TabBarView(
                          controller: _tabController,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(16),
                              child: ShadowCard(
                                cornerRadius: 12,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 54, vertical: 24),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: CardShadowColor),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14))),
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 20,
                                            ),
                                            QrImage(
                                              data: SharedPrefUtils.get(
                                                      Constants.BOOKED_SLOT_ID)
                                                  .toString(),
                                              version: QrVersions.auto,
                                              size: 200,
                                            ),
                                            SizedBox(
                                              height: 24,
                                            ),
                                            SvgPicture.asset(
                                              "assets/vectors/dashed_line.svg",
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      Text(
                                                        "60",
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: PrimaryColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        "MINS",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: PrimaryColor,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    children: <Widget>[
                                                      Text(
                                                        DateUtils.getFormattedDateInWords(
                                                            DateUtils.getDateTimeFromString(
                                                                notifier
                                                                    .bookedSlot
                                                                    .slotInfo
                                                                    .bookingDate,
                                                                separator:
                                                                    "-")),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${notifier.bookedSlot.slotInfo.startTime}:00 - ${notifier.bookedSlot.slotInfo.endTime}:00",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "This code is valid to go to ",
                                              style: TextStyle(
                                                color: SecondaryTextColor,
                                              ),
                                            ),
                                            TextSpan(
                                              text: notifier.bookedSlot
                                                  .merchantInfo.shopName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: SecondaryTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          "Get Direction",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: PrimaryColor,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ListView(
                              children: <Widget>[],
                            )
                          ],
                        )
                      : Center(
                          child: Text("No active slot available"),
                        )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: GestureDetector(
                child: Text(
                  "CANCEL SLOT",
                  style: TextStyle(
                    fontSize: 16,
                    color: SecondaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () {},
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String tabName, int tabIndex) {
    return Container(
      decoration: _currentTab == tabIndex
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
        tabName,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

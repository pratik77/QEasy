import 'package:covidpass/provider/slot_notifier.dart';
import 'package:covidpass/screens/dashboard.dart';
import 'package:covidpass/utils/colors.dart';
import 'package:covidpass/utils/date_utils.dart';
import 'package:covidpass/widgets/shadow_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SlotBookingSuccess extends StatefulWidget {
  final int slotId;

  SlotBookingSuccess(this.slotId);

  @override
  _SlotBookingSuccessState createState() => _SlotBookingSuccessState();
}

class _SlotBookingSuccessState extends State<SlotBookingSuccess> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SlotNotifier>(
      create: (context) => SlotNotifier(widget.slotId),
      child: Consumer<SlotNotifier>(
        builder: (context, notifier, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard(
                          initialIndex: 1,
                        ),
                      ),
                      (route) => false);
                }),
          ),
          body: notifier.isRequestFinished
              ? notifier.bookedSlot != null
                  ? Column(
                      children: <Widget>[
                        Flexible(
                          child: Container(
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
                                            height: 24,
                                          ),
                                          QrImage(
                                            data: widget.slotId.toString(),
                                            version: QrVersions.auto,
                                            size: 200,
                                          ),
                                          SizedBox(
                                            height: 32,
                                          ),
                                          SvgPicture.asset(
                                            "assets/vectors/dashed_line.svg",
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
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
                                                          DateUtils
                                                              .getDateTimeFromString(
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
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          flex: 4,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: TabBackgroundColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 48),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Tap the"),
                                    CircleAvatar(
                                      child: SvgPicture.asset(
                                        "assets/vectors/qr_code.svg",
                                        color: PrimaryDarkColor,
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    Text("icon to view all your QR codes"),
                                  ],
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
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Dashboard(
                                                  initialIndex: 1,
                                                )),
                                        (route) => false);
                                  },
                                  child: Text(
                                    "OKAY!!",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text("No active slot available"),
                    )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}

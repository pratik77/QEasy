import 'package:covidpass/provider/verify_slot_notifier.dart';
import 'package:covidpass/screens/dashboard.dart';
import 'package:covidpass/utils/colors.dart';
import 'package:covidpass/utils/constants.dart';
import 'package:covidpass/utils/date_utils.dart';
import 'package:covidpass/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ValidateQr extends StatefulWidget {
  final int slotId;

  ValidateQr(this.slotId);

  @override
  _ValidateQrState createState() => _ValidateQrState();
}

class _ValidateQrState extends State<ValidateQr> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ),
          (route) => false),
      child: ChangeNotifierProvider<VerifySlotNotifier>(
        create: (context) => VerifySlotNotifier(widget.slotId),
        child: Consumer<VerifySlotNotifier>(
          builder: (context, notifier, child) => Scaffold(
            appBar: AppBar(
              title: Text(
                "QR Verification",
                style: TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                color: Colors.white,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard(),
                      ),
                      (route) => false);
                },
              ),
            ),
            body: notifier.isRequestFinished
                ? notifier.bookedSlot != null
                    ? SharedPrefUtils.get(Constants.USER_TYPE) == "merchant"
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset("assets/vectors/ic_correct.svg"),
                              SizedBox(
                                height: 16,
                              ),
                              Text("You have approved the purchase"),
                              SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                      "assets/vectors/ic_clock.svg"),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  notifier.isRequestFinished
                                      ? notifier.currenAddress != null
                                          ? Expanded(
                                              child: Text(
                                                notifier
                                                    .currenAddress.addressLine,
                                                maxLines: 1,
                                              ),
                                            )
                                          : Text("Location Disabled")
                                      : CircularProgressIndicator(),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    DateUtils.getFormattedDateInWords(
                                        DateUtils.getDateTimeFromString(
                                            notifier.bookedSlot.slotInfo
                                                .bookingDate,
                                            separator: "-")),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${notifier.bookedSlot.slotInfo.startTime}:00 - ${notifier.bookedSlot.slotInfo.endTime}:00",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset("assets/vectors/ic_correct.svg"),
                              SizedBox(
                                height: 16,
                              ),
                              Text("This user is authorised to move"),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                notifier.bookedSlot.merchantInfo.shopName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                      "assets/vectors/ic_location.svg"),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text("Slot Time"),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                      "assets/vectors/ic_clock.svg"),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        DateUtils.getFormattedDateInWords(
                                            DateUtils.getDateTimeFromString(
                                                notifier.bookedSlot.slotInfo
                                                    .bookingDate,
                                                separator: "-")),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
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
                              )
                            ],
                          )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.clear,
                              color: ErrorColor,
                              size: 48,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text("Invalid Slot or Slot has expired")
                          ],
                        ),
                      )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }
}

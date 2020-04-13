import 'package:covidpass/enums/user_role.dart';
import 'package:covidpass/models/api_response.dart';
import 'package:covidpass/models/booked_slot.dart';
import 'package:covidpass/repository/data_repository.dart';
import 'package:covidpass/utils/constants.dart';
import 'package:covidpass/utils/location_utils.dart';
import 'package:covidpass/utils/shared_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoder/model.dart';

class VerifySlotNotifier with ChangeNotifier {
  BookedSlot _bookedSlot;
  bool _isRequestFinished = false;
  Address _address;

  BookedSlot get bookedSlot => _bookedSlot;
  bool get isRequestFinished => _isRequestFinished;
  Address get currenAddress => _address;

  VerifySlotNotifier(int slotId) {
    getSlotInformation(slotId);
  }

  void getSlotInformation(int slotId) async {
    try {
      _isRequestFinished = false;
      notifyListeners();
      ApiResponse response = await DataRepository.instance.getSlotInformation(
        slotId,
        isForMerchant: SharedPrefUtils.get(Constants.USER_TYPE) == "merchant",
      );
      _bookedSlot = BookedSlot.fromJson(response.data);
      _isRequestFinished = true;
      notifyListeners();
    } catch (e) {
      print(e.message);
      _isRequestFinished = true;
      notifyListeners();
    }
  }

  void getLocationByLatLong(double lat, double long) async {
    List<Address> addresses =
        await LocationUtils.getLocationFromCoordinates(lat, long);
    _address = addresses.first;
    notifyListeners();
  }
}

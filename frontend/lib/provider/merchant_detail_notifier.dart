import 'package:covidpass/models/api_response.dart';
import 'package:covidpass/models/gift_item.dart';
import 'package:covidpass/models/slot_info.dart';
import 'package:covidpass/repository/data_repository.dart';
import 'package:covidpass/utils/location_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoder/model.dart';

class MerchantDetailNotifier with ChangeNotifier {
  List<dynamic> _availableSlots;
  bool _isRequestFinished = false;
  List<dynamic> _giftItems;
  Address _address;

  List<dynamic> get availableSlots => _availableSlots;
  List<dynamic> get giftItems => _giftItems;
  bool get isRequestFinished => _isRequestFinished;
  Address get currentAddress => _address;

  MerchantDetailNotifier(int merchantId, int userId, double lat, double long) {
    getAvailableSlots(merchantId, userId);
    getLocationByLatLong(lat, long);
    getGiftCards(merchantId);
  }

  void getAvailableSlots(int merchantId, int userId) async {
    try {
      _isRequestFinished = false;
      notifyListeners();
      ApiResponse response =
          await DataRepository.instance.getAvailableSlots(merchantId, userId);
      _availableSlots =
          response.data.map((it) => SlotInfo.fromJson(it)).toList();
      _isRequestFinished = true;
      notifyListeners();
    } catch (e) {
      print(e.message);
      _isRequestFinished = true;
      notifyListeners();
    }
  }

  void getGiftCards(int merchantId) async {
    try {
      _isRequestFinished = false;
      notifyListeners();
      ApiResponse response =
          await DataRepository.instance.getAllGifts({"merchantId": merchantId});
      _giftItems = response.data.map((it) => GiftItem.fromJson(it)).toList();
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

import 'package:covidpass/enums/user_role.dart';
import 'package:covidpass/models/api_response.dart';
import 'package:covidpass/models/gift_item.dart';
import 'package:covidpass/models/item.dart';
import 'package:covidpass/models/user.dart';
import 'package:covidpass/services/api_service.dart';
import 'package:covidpass/utils/constants.dart';
import 'package:covidpass/utils/shared_pref.dart';
import 'package:covidpass/utils/user_role_serializer.dart';
import 'package:dio/dio.dart';

class DataRepository {
  static DataRepository _dataRepository;
  static DataRepository get instance => _dataRepository ?? DataRepository._();

  DataRepository._();

  Dio _dio;
  Dio _getDio({
    bool addToken = false,
    String contentType = "application/json",
    bool isFileOperation = false,
  }) {
    if (_dio == null) {
      _dio = Dio();
    }
    _dio.options.headers["content-type"] = contentType;
    _dio.interceptors.add(
      InterceptorsWrapper(
          onRequest: (options) {
            if (isFileOperation) {
              options.headers["accept-encoding"] = "*";
            }
            /* if (addToken) {
          options.headers["authorization"] =
              "Bearer ${SharedPrefUtils.get(Constants.ACCESS_TOKEN)}";
        } else {
          options.headers.remove("authorization");
        } */
            return options;
          },
          onResponse: (response) {
            return response;
          },
          onError: (dioError) {}),
    );
    return _dio;
  }

  Future<ApiResponse> login(String phone, String pwd) {
    return ApiService(_getDio()).login({"phoneNumber": phone, "password": pwd});
  }

  Future<ApiResponse> register(User user) {
    return ApiService(_getDio()).register(user.toJson());
  }

  Future<ApiResponse> getAllMerchants(String lat, String long) {
    return ApiService(_getDio()).getAllMerchants({"lat": lat, "lng": long});
  }

  Future<ApiResponse> getAvailableSlots(int merchantId, int userId) {
    return ApiService(_getDio())
        .getAvailableSlots({"merchantId": merchantId, "userId": userId});
  }

  Future<ApiResponse> bookSlot(Map<String, dynamic> slotDetails) {
    return ApiService(_getDio()).bookSlot(slotDetails);
  }

  Future<ApiResponse> getProfileInfo(int userId, UserRole userType) {
    switch (userType) {
      case UserRole.CUSTOMER:
        return ApiService(_getDio()).getProfileInfo({
          "normalUserId": userId,
          "userType": UserRoleSerializer.getRoleFromEnum(userType)
        });
        break;
      case UserRole.MERCHANT:
        return ApiService(_getDio()).getProfileInfo({
          "merchantId": userId,
          "userType": UserRoleSerializer.getRoleFromEnum(userType)
        });
        break;
      case UserRole.POLICE:
        return ApiService(_getDio()).getProfileInfo({
          "policeUserId": userId,
          "userType": UserRoleSerializer.getRoleFromEnum(userType)
        });
        break;
      default:
        return null;
    }
  }

  Future<ApiResponse> getSlotInformation(int slotId,
      {bool isForMerchant = false}) {
    if (isForMerchant) {
      return ApiService(_getDio()).getSlotInformation(
        {
          "slotId": slotId,
          "merchantId": SharedPrefUtils.get(Constants.USER_ID)
        },
      );
    } else {
      return ApiService(_getDio()).getSlotInformation({"slotId": slotId});
    }
  }

  Future<ApiResponse> getNextActiveSlotDetails(int userId) {
    return ApiService(_getDio()).getNextActiveSlotDetails({"userId": userId});
  }

  Future<ApiResponse> addGift(GiftItem giftItem) {
    return ApiService(_getDio()).addGift(giftItem.toJson());
  }

  Future<ApiResponse> deleteGift(Map<String, dynamic> body) {
    return ApiService(_getDio()).deleteGift(body);
  }

  Future<ApiResponse> updateGift(Map<String, dynamic> body) {
    return ApiService(_getDio()).updateGift(body);
  }

  Future<ApiResponse> getAllGifts(Map<String, dynamic> body) {
    return ApiService(_getDio()).getAllGifts(body);
  }

  Future<ApiResponse> buyGift(Map<String, dynamic> body) {
    return ApiService(_getDio()).buyGift(body);
  }

  // Items apis

  Future<ApiResponse> addItem(List<Item> items) {
    return ApiService(_getDio()).addItem({"items": items});
  }

  Future<ApiResponse> deleteItem(Map<String, dynamic> body) {
    return ApiService(_getDio()).deleteItem(body);
  }

  Future<ApiResponse> updateItem(Map<String, dynamic> body) {
    return ApiService(_getDio()).updateItem(body);
  }

  Future<ApiResponse> getAllItems(Map<String, dynamic> body) {
    return ApiService(_getDio()).getAllItems(body);
  }
}

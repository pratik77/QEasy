import 'package:covidpass/models/api_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://3.17.180.234:5051")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("/login")
  Future<ApiResponse> login(@Body() Map<String, dynamic> loginDetails);

  @POST("/register")
  Future<ApiResponse> register(@Body() Map<String, dynamic> userDetails);

  @POST("/getAllMerchantDetails")
  Future<ApiResponse> getAllMerchants(
      @Body() Map<String, dynamic> userLocation);

  @POST("/getAvailableSlots")
  Future<ApiResponse> getAvailableSlots(@Body() Map<String, dynamic> body);

  @POST("/bookSlot")
  Future<ApiResponse> bookSlot(@Body() Map<String, dynamic> slotDetails);

  @POST("/getProfileInfo")
  Future<ApiResponse> getProfileInfo(@Body() Map<String, dynamic> userDetails);

  @POST("/getSlotInformation")
  Future<ApiResponse> getSlotInformation(@Body() Map<String, dynamic> body);

  @POST("/getNextActiveSlotDetails")
  Future<ApiResponse> getNextActiveSlotDetails(
      @Body() Map<String, dynamic> body);

  //Gifts apis

  @POST("/newGift")
  Future<ApiResponse> addGift(@Body() Map<String, dynamic> body);

  @POST("/deleteGift")
  Future<ApiResponse> deleteGift(@Body() Map<String, dynamic> body);

  @POST("/updateGift")
  Future<ApiResponse> updateGift(@Body() Map<String, dynamic> body);

  @POST("/getAllGifts")
  Future<ApiResponse> getAllGifts(@Body() Map<String, dynamic> body);

  @POST("/buyGift")
  Future<ApiResponse> buyGift(@Body() Map<String, dynamic> body);

  // Items apis

  @POST("/newItem")
  Future<ApiResponse> addItem(@Body() Map<String, dynamic> body);

  @POST("/deleteItem")
  Future<ApiResponse> deleteItem(@Body() Map<String, dynamic> body);

  @POST("/updateItem")
  Future<ApiResponse> updateItem(@Body() Map<String, dynamic> body);

  @POST("/getItemAll")
  Future<ApiResponse> getAllItems(@Body() Map<String, dynamic> body);
}

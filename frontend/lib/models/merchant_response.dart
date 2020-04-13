import 'package:covidpass/models/merchant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'merchant_response.g.dart';

@JsonSerializable()
class MerchantResponse {
  String responseCode;
  String message;
  List<Merchant> merchants;

  MerchantResponse();

  factory MerchantResponse.fromJson(Map<String, dynamic> json) =>
      _$MerchantResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MerchantResponseToJson(this);
}
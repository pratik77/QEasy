import 'package:covidpass/enums/store_category.dart';
import 'package:covidpass/enums/user_role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(includeIfNull: false)
  int userId;
  UserRole userType;
  String phoneNumber;
  @JsonKey(includeIfNull: false)
  String firstName;
  @JsonKey(includeIfNull: false)
  String lastName;
  @JsonKey(includeIfNull: false)
  String electricityBillNumber;
  String lat;
  String lng;
  String password;
  @JsonKey(includeIfNull: false)
  String shopName;
  @JsonKey(includeIfNull: false)
  StoreCategory shopCategory;
  @JsonKey(includeIfNull: false)
  String gstNumber;
  @JsonKey(includeIfNull: false)
  String maxSlots;
  @JsonKey(includeIfNull: false)
  List<int> activeSlots;

  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

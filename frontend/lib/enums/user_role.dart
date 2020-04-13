import 'package:json_annotation/json_annotation.dart';

enum UserRole {
  @JsonValue("normalUser")
  CUSTOMER,
  @JsonValue("merchant")
  MERCHANT,
  @JsonValue("police")
  POLICE
}

import 'package:json_annotation/json_annotation.dart';

enum StoreCategory {
  ALL,
  @JsonValue("grocery")
  GROCERIES,
  @JsonValue("medicine")
  MEDICINES,
  @JsonValue("meat")
  MEAT
}

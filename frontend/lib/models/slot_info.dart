import 'package:json_annotation/json_annotation.dart';

part 'slot_info.g.dart';

@JsonSerializable()
class SlotInfo {
  String date;
  int startTime;
  int endTime;

  SlotInfo();

  factory SlotInfo.fromJson(Map<String, dynamic> json) =>
      _$SlotInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SlotInfoToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'gift_item.g.dart';

@JsonSerializable()
class GiftItem {
  int giftId;
  String giftName;
  String amount;

  GiftItem();

  factory GiftItem.fromJson(Map<String, dynamic> json) =>
      _$GiftItemFromJson(json);
  Map<String, dynamic> toJson() => _$GiftItemToJson(this);
}

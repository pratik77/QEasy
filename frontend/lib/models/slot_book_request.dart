import 'package:json_annotation/json_annotation.dart';

part 'slot_book_request.g.dart';

@JsonSerializable()
class SlotBookRequest {
  int startTime;
  int endTime;
  int userId;
  String bookingDate;
  int merchantId;

  SlotBookRequest();

  factory SlotBookRequest.fromJson(Map<String, dynamic> json) =>
      _$SlotBookRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SlotBookRequestToJson(this);
}

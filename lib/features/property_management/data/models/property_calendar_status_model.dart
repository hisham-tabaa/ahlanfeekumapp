import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/property_calendar_status.dart';

part 'property_calendar_status_model.g.dart';

@JsonSerializable()
class PropertyCalendarStatusModel {
  final String? propertyId;
  final String? date;
  final bool? isAvailable;
  final double? price;
  final String? note;
  final bool? isBooked;
  final String? status; // API returns status as string: "Available", "Booked", "Unavailable"

  PropertyCalendarStatusModel({
    this.propertyId,
    this.date,
    this.isAvailable,
    this.price,
    this.note,
    this.isBooked,
    this.status,
  });

  factory PropertyCalendarStatusModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyCalendarStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyCalendarStatusModelToJson(this);

  PropertyCalendarStatus toEntity() {
    // Determine if booked from status field if isBooked is not provided
    bool booked = isBooked ?? false;
    if (status != null && status!.toLowerCase() == 'booked') {
      booked = true;
    }
    
    return PropertyCalendarStatus(
      propertyId: propertyId ?? '',
      date: DateTime.tryParse(date ?? '') ?? DateTime.now(),
      isAvailable: isAvailable ?? false,
      price: price,
      note: note,
      isBooked: booked,
    );
  }

  factory PropertyCalendarStatusModel.fromEntity(PropertyCalendarStatus entity) {
    return PropertyCalendarStatusModel(
      propertyId: entity.propertyId,
      date: entity.date.toIso8601String().split('T').first,
      isAvailable: entity.isAvailable,
      price: entity.price,
      note: entity.note,
      isBooked: entity.isBooked,
    );
  }
}

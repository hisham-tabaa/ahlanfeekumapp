import 'package:equatable/equatable.dart';

class PropertyCalendarStatus extends Equatable {
  final String propertyId;
  final DateTime date;
  final bool isAvailable;
  final double? price;
  final String? note;
  final bool isBooked;

  const PropertyCalendarStatus({
    required this.propertyId,
    required this.date,
    required this.isAvailable,
    this.price,
    this.note,
    this.isBooked = false,
  });

  @override
  List<Object?> get props => [
        propertyId,
        date,
        isAvailable,
        price,
        note,
        isBooked,
      ];
}

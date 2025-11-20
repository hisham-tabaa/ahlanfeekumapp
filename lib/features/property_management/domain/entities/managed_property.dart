import 'package:equatable/equatable.dart';

class ManagedProperty extends Equatable {
  final String id;
  final String title;
  final String? imageUrl;
  final double price;
  final bool isActive;
  final String? location;
  final int? totalBookings;
  final double? rating;

  const ManagedProperty({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.price,
    required this.isActive,
    this.location,
    this.totalBookings,
    this.rating,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        imageUrl,
        price,
        isActive,
        location,
        totalBookings,
        rating,
      ];
}

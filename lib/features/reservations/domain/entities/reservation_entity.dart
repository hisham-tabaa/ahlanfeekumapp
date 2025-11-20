import 'package:equatable/equatable.dart';

class ReservationEntity extends Equatable {
  final String id;
  final String fromDate;
  final String toDate;
  final String? checkInDate;
  final String? checkOutDate;
  final int numberOfGuest;
  final double price;
  final double discount;
  final int reservationStatus;
  final String reservationStatusAsString;
  final String? notes;
  final String userProfileId;
  final String userProfileName;
  final String? userProfilePhoto;
  final String ownerId;
  final String ownerName;
  final String? ownerProfilePhoto;
  final String propertyId;
  final String propertyTitle;
  final String propertyArea;
  final String? propertyMainImage;

  const ReservationEntity({
    required this.id,
    required this.fromDate,
    required this.toDate,
    this.checkInDate,
    this.checkOutDate,
    required this.numberOfGuest,
    required this.price,
    required this.discount,
    required this.reservationStatus,
    required this.reservationStatusAsString,
    this.notes,
    required this.userProfileId,
    required this.userProfileName,
    this.userProfilePhoto,
    required this.ownerId,
    required this.ownerName,
    this.ownerProfilePhoto,
    required this.propertyId,
    required this.propertyTitle,
    required this.propertyArea,
    this.propertyMainImage,
  });

  @override
  List<Object?> get props => [
        id,
        fromDate,
        toDate,
        checkInDate,
        checkOutDate,
        numberOfGuest,
        price,
        discount,
        reservationStatus,
        reservationStatusAsString,
        notes,
        userProfileId,
        userProfileName,
        userProfilePhoto,
        ownerId,
        ownerName,
        ownerProfilePhoto,
        propertyId,
        propertyTitle,
        propertyArea,
        propertyMainImage,
      ];

  // Helper methods
  DateTime get fromDateTime => DateTime.parse(fromDate);
  DateTime get toDateTime => DateTime.parse(toDate);
  
  DateTime? get checkInDateTime => 
      checkInDate != null ? DateTime.parse(checkInDate!) : null;
  
  DateTime? get checkOutDateTime => 
      checkOutDate != null ? DateTime.parse(checkOutDate!) : null;

  bool get isPending => reservationStatus == 1;
  bool get isConfirmed => reservationStatus == 2;
  bool get isCancelled => reservationStatus == 3;
  bool get isCompleted => reservationStatus == 4;

  String get statusColor {
    switch (reservationStatus) {
      case 1: return '#FFA500'; // Orange for Pending
      case 2: return '#4CAF50'; // Green for Confirmed
      case 3: return '#F44336'; // Red for Cancelled
      case 4: return '#2196F3'; // Blue for Completed
      default: return '#9E9E9E'; // Grey for Unknown
    }
  }
}

class ReservationListEntity extends Equatable {
  final List<ReservationEntity> reservations;
  final int totalCount;

  const ReservationListEntity({
    required this.reservations,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [reservations, totalCount];
}



enum ReservationStatus {
  pending(1),
  approved(2),
  declined(3);

  const ReservationStatus(this.value);
  final int value;

  static ReservationStatus fromValue(int value) {
    switch (value) {
      case 1:
        return ReservationStatus.pending;
      case 2:
        return ReservationStatus.approved;
      case 3:
        return ReservationStatus.declined;
      default:
        return ReservationStatus.pending;
    }
  }

  String get displayName {
    switch (this) {
      case ReservationStatus.pending:
        return 'Pending';
      case ReservationStatus.approved:
        return 'Confirmed';
      case ReservationStatus.declined:
        return 'Not Available';
    }
  }
}

class Reservation {
  final String id;
  final DateTime fromDate;
  final DateTime toDate;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int numberOfGuest;
  final double price;
  final double discount;
  final ReservationStatus status;
  final String? notes;
  final String userProfileId;
  final String userProfileName;
  final String userProfilePhoto;
  final String ownerId;
  final String ownerName;
  final String ownerProfilePhoto;
  final String propertyId;
  final String propertyTitle;
  final String propertyArea;
  final String propertyMainImage;

  const Reservation({
    required this.id,
    required this.fromDate,
    required this.toDate,
    this.checkInDate,
    this.checkOutDate,
    required this.numberOfGuest,
    required this.price,
    required this.discount,
    required this.status,
    this.notes,
    required this.userProfileId,
    required this.userProfileName,
    required this.userProfilePhoto,
    required this.ownerId,
    required this.ownerName,
    required this.ownerProfilePhoto,
    required this.propertyId,
    required this.propertyTitle,
    required this.propertyArea,
    required this.propertyMainImage,
  });

  int get daysLeft {
    final now = DateTime.now();
    final difference = fromDate.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }
}

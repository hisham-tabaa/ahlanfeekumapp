import '../../domain/entities/reservation.dart';
import '../models/reservation_response.dart';

extension ReservationResponseMapper on ReservationResponse {
  Reservation toEntity() {
    return Reservation(
      id: id,
      fromDate: DateTime.parse(fromeDate),
      toDate: DateTime.parse(toDate),
      checkInDate: checkInDate != null ? DateTime.parse(checkInDate!) : null,
      checkOutDate: checkOutDate != null ? DateTime.parse(checkOutDate!) : null,
      numberOfGuest: numberOfGuest,
      price: price,
      discount: discount,
      status: ReservationStatus.fromValue(reservationStatus),
      notes: notes,
      userProfileId: userProfileId,
      userProfileName: userProfileName,
      userProfilePhoto: userProfilePhoto,
      ownerId: ownerId,
      ownerName: ownerName,
      ownerProfilePhoto: ownerProfilePhoto,
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      propertyArea: propertyArea,
      propertyMainImage: propertyMainImage ?? '',
    );
  }
}

extension ReservationResponseListMapper on List<ReservationResponse> {
  List<Reservation> toEntities() {
    return map((response) => response.toEntity()).toList();
  }
}

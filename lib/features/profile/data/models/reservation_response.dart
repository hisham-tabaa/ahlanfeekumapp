class ReservationResponse {
  final String id;
  final String fromeDate;
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
  final String userProfilePhoto;
  final String ownerId;
  final String ownerName;
  final String ownerProfilePhoto;
  final String propertyId;
  final String propertyTitle;
  final String propertyArea;
  final String? propertyMainImage;

  const ReservationResponse({
    required this.id,
    required this.fromeDate,
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
    required this.userProfilePhoto,
    required this.ownerId,
    required this.ownerName,
    required this.ownerProfilePhoto,
    required this.propertyId,
    required this.propertyTitle,
    required this.propertyArea,
    this.propertyMainImage,
  });

  factory ReservationResponse.fromJson(Map<String, dynamic> json) {
    return ReservationResponse(
      id: json['id'] as String,
      fromeDate: json['fromeDate'] as String,
      toDate: json['toDate'] as String,
      checkInDate: json['checkInDate'] as String?,
      checkOutDate: json['checkOutDate'] as String?,
      numberOfGuest: json['numberOfGuest'] as int,
      price: (json['price'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      reservationStatus: json['reservationStatus'] as int,
      reservationStatusAsString: json['reservationStatusAsString'] as String,
      notes: json['notes'] as String?,
      userProfileId: json['userProfileId'] as String,
      userProfileName: json['userProfileName'] as String,
      userProfilePhoto: json['userProfilePhoto'] as String,
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String,
      ownerProfilePhoto: json['ownerProfilePhoto'] as String,
      propertyId: json['propertyId'] as String,
      propertyTitle: json['propertyTitle'] as String,
      propertyArea: json['propertyArea']?.toString() ?? '0',
      propertyMainImage: json['propertyMainImage'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromeDate': fromeDate,
      'toDate': toDate,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'numberOfGuest': numberOfGuest,
      'price': price,
      'discount': discount,
      'reservationStatus': reservationStatus,
      'reservationStatusAsString': reservationStatusAsString,
      'notes': notes,
      'userProfileId': userProfileId,
      'userProfileName': userProfileName,
      'userProfilePhoto': userProfilePhoto,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerProfilePhoto': ownerProfilePhoto,
      'propertyId': propertyId,
      'propertyTitle': propertyTitle,
      'propertyArea': propertyArea,
      'propertyMainImage': propertyMainImage,
    };
  }
}

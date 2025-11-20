import 'package:equatable/equatable.dart';

class HostProfile extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? profilePhotoUrl;
  final bool isSuperHost;
  final List<HostProperty> properties;

  const HostProfile({
    required this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.address,
    this.profilePhotoUrl,
    required this.isSuperHost,
    required this.properties,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phoneNumber,
    address,
    profilePhotoUrl,
    isSuperHost,
    properties,
  ];
}

class HostProperty extends Equatable {
  final String id;
  final String? title;
  final String? address;
  final String? landMark;
  final String? mainImageUrl;
  final double pricePerNight;
  final double averageRating;
  final bool isFavorite;
  final bool isActive; // Approval status

  const HostProperty({
    required this.id,
    this.title,
    this.address,
    this.landMark,
    this.mainImageUrl,
    required this.pricePerNight,
    required this.averageRating,
    required this.isFavorite,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    address,
    landMark,
    mainImageUrl,
    pricePerNight,
    averageRating,
    isFavorite,
    isActive,
  ];
}

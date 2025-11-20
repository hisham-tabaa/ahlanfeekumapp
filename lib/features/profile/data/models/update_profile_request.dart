class UpdateProfileRequest {
  final String name;
  final String email;
  final String phoneNumber;
  final String latitude;
  final String longitude;
  final String address;
  final bool isProfilePhotoChanged;
  final String? profilePhotoPath;

  const UpdateProfileRequest({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.isProfilePhotoChanged,
    this.profilePhotoPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'Latitude': latitude,
      'Longitude': longitude,
      'Address': address,
      'IsProfilePhotoChanged': isProfilePhotoChanged,
    };
  }
}

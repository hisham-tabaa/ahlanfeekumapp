import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? profileImage;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final int?
  roleId; // 0 for admin, 1 for host, 2 for guest, 3 for visitor/guest (no auth)

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.profileImage,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    this.roleId,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    phone,
    profileImage,
    isEmailVerified,
    isPhoneVerified,
    roleId,
  ];
}

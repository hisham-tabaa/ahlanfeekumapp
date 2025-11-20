class ChangePasswordRequest {
  final String emailOrPhone;
  final String oldPassword;
  final String newPassword;

  const ChangePasswordRequest({
    required this.emailOrPhone,
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'emailOrPhone': emailOrPhone,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
  }
}

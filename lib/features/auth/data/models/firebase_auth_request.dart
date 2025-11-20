import 'package:json_annotation/json_annotation.dart';

part 'firebase_auth_request.g.dart';

@JsonSerializable()
class FirebaseAuthRequest {
  final String idToken;
  final String? fcmToken;

  const FirebaseAuthRequest({required this.idToken, this.fcmToken});

  factory FirebaseAuthRequest.fromJson(Map<String, dynamic> json) =>
      _$FirebaseAuthRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseAuthRequestToJson(this);
}

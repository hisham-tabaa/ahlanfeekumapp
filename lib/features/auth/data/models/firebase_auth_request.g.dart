// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_auth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseAuthRequest _$FirebaseAuthRequestFromJson(Map<String, dynamic> json) =>
    FirebaseAuthRequest(
      idToken: json['idToken'] as String,
      fcmToken: json['fcmToken'] as String?,
    );

Map<String, dynamic> _$FirebaseAuthRequestToJson(
        FirebaseAuthRequest instance) =>
    <String, dynamic>{
      'idToken': instance.idToken,
      'fcmToken': instance.fcmToken,
    };

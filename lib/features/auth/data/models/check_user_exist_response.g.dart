// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_user_exist_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckUserExistResponse _$CheckUserExistResponseFromJson(
        Map<String, dynamic> json) =>
    CheckUserExistResponse(
      data: json['data'] as bool,
      message: json['message'] as String,
      code: (json['code'] as num).toInt(),
    );

Map<String, dynamic> _$CheckUserExistResponseToJson(
        CheckUserExistResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'code': instance.code,
    };

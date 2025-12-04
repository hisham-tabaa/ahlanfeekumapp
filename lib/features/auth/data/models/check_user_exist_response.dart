import 'package:json_annotation/json_annotation.dart';

part 'check_user_exist_response.g.dart';

@JsonSerializable()
class CheckUserExistResponse {
  final bool data;
  final String message;
  final int code;

  CheckUserExistResponse({
    required this.data,
    required this.message,
    required this.code,
  });

  factory CheckUserExistResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckUserExistResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckUserExistResponseToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'payment_method_model.g.dart';

@JsonSerializable()
class PaymentMethodModel {
  final int id;
  final String name;
  final String? description;
  final String? icon;
  final bool isActive;

  const PaymentMethodModel({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.isActive = true,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodModelToJson(this);
}

enum ReservationPaymentMethod {
  card(1, 'Card'),
  cash(2, 'Cash');

  final int id;
  final String displayName;

  const ReservationPaymentMethod(this.id, this.displayName);

  static ReservationPaymentMethod fromId(int id) {
    return ReservationPaymentMethod.values.firstWhere(
      (method) => method.id == id,
      orElse: () => ReservationPaymentMethod.card,
    );
  }
}

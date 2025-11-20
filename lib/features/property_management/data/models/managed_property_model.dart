import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/managed_property.dart';

part 'managed_property_model.g.dart';

@JsonSerializable()
class ManagedPropertyModel {
  final String? id;
  @JsonKey(name: 'propertyTitle')
  final String? title;
  @JsonKey(name: 'mainImage')
  final String? imageUrl;
  @JsonKey(name: 'pricePerNight')
  final double? price;
  final bool? isActive;
  @JsonKey(name: 'streetAndBuildingNumber')
  final String? location;
  final int? totalBookings;
  @JsonKey(name: 'averageRating')
  final double? rating;

  ManagedPropertyModel({
    this.id,
    this.title,
    this.imageUrl,
    this.price,
    this.isActive,
    this.location,
    this.totalBookings,
    this.rating,
  });

  factory ManagedPropertyModel.fromJson(Map<String, dynamic> json) =>
      _$ManagedPropertyModelFromJson(json);

  Map<String, dynamic> toJson() => _$ManagedPropertyModelToJson(this);

  ManagedProperty toEntity() {
    return ManagedProperty(
      id: id ?? '',
      title: title ?? '',
      imageUrl: imageUrl,
      price: price ?? 0.0,
      isActive: isActive ?? false,
      location: location,
      totalBookings: totalBookings,
      rating: rating,
    );
  }
}

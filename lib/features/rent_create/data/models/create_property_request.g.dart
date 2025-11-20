// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_property_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePropertyStepOneRequest _$CreatePropertyStepOneRequestFromJson(
        Map<String, dynamic> json) =>
    CreatePropertyStepOneRequest(
      propertyTitle: json['propertyTitle'] as String,
      hotelName: json['hotelName'] as String?,
      bedrooms: (json['bedrooms'] as num).toInt(),
      bathrooms: (json['bathrooms'] as num).toInt(),
      numberOfBed: (json['numberOfBed'] as num).toInt(),
      floor: (json['floor'] as num).toInt(),
      maximumNumberOfGuest: (json['maximumNumberOfGuest'] as num).toInt(),
      livingrooms: (json['livingrooms'] as num).toInt(),
      area: (json['area'] as num).toInt(),
      propertyDescription: json['propertyDescription'] as String,
      hourseRules: json['hourseRules'] as String,
      importantInformation: json['importantInformation'] as String,
      address: json['address'] as String,
      streetAndBuildingNumber: json['streetAndBuildingNumber'] as String,
      landMark: json['landMark'] as String,
      pricePerNight: (json['pricePerNight'] as num).toInt(),
      isActive: json['isActive'] as bool? ?? true,
      propertyTypeId: json['propertyTypeId'] as String,
      governorateId: json['governorateId'] as String,
      propertyFeatureIds: (json['propertyFeatureIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
    );

Map<String, dynamic> _$CreatePropertyStepOneRequestToJson(
        CreatePropertyStepOneRequest instance) =>
    <String, dynamic>{
      'propertyTitle': instance.propertyTitle,
      'hotelName': instance.hotelName,
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'numberOfBed': instance.numberOfBed,
      'floor': instance.floor,
      'maximumNumberOfGuest': instance.maximumNumberOfGuest,
      'livingrooms': instance.livingrooms,
      'area': instance.area,
      'propertyDescription': instance.propertyDescription,
      'hourseRules': instance.hourseRules,
      'importantInformation': instance.importantInformation,
      'address': instance.address,
      'streetAndBuildingNumber': instance.streetAndBuildingNumber,
      'landMark': instance.landMark,
      'pricePerNight': instance.pricePerNight,
      'isActive': instance.isActive,
      'propertyTypeId': instance.propertyTypeId,
      'governorateId': instance.governorateId,
      'propertyFeatureIds': instance.propertyFeatureIds,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

CreatePropertyStepTwoRequest _$CreatePropertyStepTwoRequestFromJson(
        Map<String, dynamic> json) =>
    CreatePropertyStepTwoRequest(
      id: json['id'] as String,
      address: json['address'] as String,
      streetAndBuildingNumber: json['streetAndBuildingNumber'] as String,
      landMark: json['landMark'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );

Map<String, dynamic> _$CreatePropertyStepTwoRequestToJson(
        CreatePropertyStepTwoRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'streetAndBuildingNumber': instance.streetAndBuildingNumber,
      'landMark': instance.landMark,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

PropertyAvailability _$PropertyAvailabilityFromJson(
        Map<String, dynamic> json) =>
    PropertyAvailability(
      propertyId: json['propertyId'] as String,
      date: json['date'] as String,
      isAvailable: json['isAvailable'] as bool,
      price: (json['price'] as num).toInt(),
      note: json['note'] as String,
    );

Map<String, dynamic> _$PropertyAvailabilityToJson(
        PropertyAvailability instance) =>
    <String, dynamic>{
      'propertyId': instance.propertyId,
      'date': instance.date,
      'isAvailable': instance.isAvailable,
      'price': instance.price,
      'note': instance.note,
    };

PropertyMediaUpload _$PropertyMediaUploadFromJson(Map<String, dynamic> json) =>
    PropertyMediaUpload(
      propertyId: json['propertyId'] as String,
      image: json['image'] as String,
      order: (json['order'] as num).toInt(),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$PropertyMediaUploadToJson(
        PropertyMediaUpload instance) =>
    <String, dynamic>{
      'propertyId': instance.propertyId,
      'image': instance.image,
      'order': instance.order,
      'isActive': instance.isActive,
    };

SetPriceRequest _$SetPriceRequestFromJson(Map<String, dynamic> json) =>
    SetPriceRequest(
      propertyId: json['propertyId'] as String,
      pricePerNight: (json['pricePerNight'] as num).toInt(),
    );

Map<String, dynamic> _$SetPriceRequestToJson(SetPriceRequest instance) =>
    <String, dynamic>{
      'propertyId': instance.propertyId,
      'pricePerNight': instance.pricePerNight,
    };

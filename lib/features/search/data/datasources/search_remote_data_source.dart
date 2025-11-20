import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/lookup_item.dart';
import '../models/property.dart';
import '../models/search_filter.dart';

abstract class SearchRemoteDataSource {
  Future<LookupResponse> getPropertyTypes();
  Future<LookupResponse> getPropertyFeatures();
  Future<LookupResponse> getGovernates();
  Future<PropertySearchResponse> searchProperties(Map<String, dynamic> queries);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio _dio;

  SearchRemoteDataSourceImpl(this._dio);

  @override
  Future<LookupResponse> getPropertyTypes() async {
    try {
      final response = await _dio.get(AppConstants.propertyTypesEndpoint);
      return LookupResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LookupResponse> getPropertyFeatures() async {
    try {
      final response = await _dio.get(AppConstants.propertyFeaturesEndpoint);
      return LookupResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LookupResponse> getGovernates() async {
    try {
      final response = await _dio.get(AppConstants.governatesEndpoint);
      return LookupResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PropertySearchResponse> searchProperties(
    Map<String, dynamic> queries,
  ) async {
    try {

      final response = await _dio.get(
        AppConstants.searchPropertyEndpoint,
        queryParameters: queries,
      );


      return PropertySearchResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

abstract class SearchRemoteDataSourceHelper {
  static Map<String, dynamic> filterToQueryMap(SearchFilter filter) {
    
    final Map<String, dynamic> queryMap = {};

    if (filter.filterText != null && filter.filterText!.isNotEmpty) {
      queryMap['FilterText'] = filter.filterText;
    }

    if (filter.propertyTypeId != null) {
      queryMap['PropertyTypeId'] = filter.propertyTypeId;
    }

    if (filter.checkInDate != null) {
      // Convert milliseconds to MM/DD/YYYY format
      final checkInDateTime = DateTime.fromMillisecondsSinceEpoch(filter.checkInDate!);
      final checkInFormatted = '${checkInDateTime.month}/${checkInDateTime.day}/${checkInDateTime.year}';
      queryMap['CheckInDate'] = checkInFormatted;
    }

    if (filter.checkOutDate != null) {
      // Convert milliseconds to MM/DD/YYYY format
      final checkOutDateTime = DateTime.fromMillisecondsSinceEpoch(filter.checkOutDate!);
      final checkOutFormatted = '${checkOutDateTime.month}/${checkOutDateTime.day}/${checkOutDateTime.year}';
      queryMap['CheckOutDate'] = checkOutFormatted;
    }

    if (filter.pricePerNightMin != null) {
      queryMap['PricePerNightMin'] = filter.pricePerNightMin;
    }

    if (filter.pricePerNightMax != null) {
      queryMap['PricePerNightMax'] = filter.pricePerNightMax;
    }

    if (filter.address != null && filter.address!.isNotEmpty) {
      queryMap['Address'] = filter.address;
    }

    if (filter.bedroomsMin != null) {
      queryMap['BedroomsMin'] = filter.bedroomsMin;
    }

    if (filter.bedroomsMax != null) {
      queryMap['BedroomsMax'] = filter.bedroomsMax;
    }

    if (filter.bathroomsMin != null) {
      queryMap['BathroomsMin'] = filter.bathroomsMin;
    }

    if (filter.bathroomsMax != null) {
      queryMap['BathroomsMax'] = filter.bathroomsMax;
    }

    if (filter.numberOfBedMin != null) {
      queryMap['NumberOfBedMin'] = filter.numberOfBedMin;
    }

    if (filter.numberOfBedMax != null) {
      queryMap['NumberOfBedMax'] = filter.numberOfBedMax;
    }

    if (filter.governorateId != null && filter.governorateId!.isNotEmpty) {
      queryMap['GovernorateId'] = filter.governorateId;
    }

    if (filter.hotelName != null && filter.hotelName!.isNotEmpty) {
      queryMap['HotelName'] = filter.hotelName;
    }

    if (filter.maximumNumberOfGuestMin != null) {
      queryMap['MaximumNumberOfGuestMin'] = filter.maximumNumberOfGuestMin;
    }

    if (filter.maximumNumberOfGuestMax != null) {
      queryMap['MaximumNumberOfGuestMax'] = filter.maximumNumberOfGuestMax;
    }

    if (filter.livingroomsMin != null) {
      queryMap['LivingroomsMin'] = filter.livingroomsMin;
    }

    if (filter.livingroomsMax != null) {
      queryMap['LivingroomsMax'] = filter.livingroomsMax;
    }

    if (filter.latitude != null) {
      queryMap['Latitude'] = filter.latitude;
    }

    if (filter.longitude != null) {
      queryMap['Longitude'] = filter.longitude;
    }

    if (filter.isActive != null) {
      queryMap['IsActive'] = filter.isActive;
    }

    queryMap['SkipCount'] = filter.skipCount;
    queryMap['MaxResultCount'] = filter.maxResultCount;

    
    // Show which of the 4 basic filters are included

    return queryMap;
  }
}
